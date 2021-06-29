# frozen_string_literal: true

require 'calstate/metadata'
require 'colorize'
require 'time'
require 'yaml'
require 'zip'

module CalState
  module Packager
    #
    # Dspace migration
    #
    class Dspace

      #
      # Optional time to sleep between each package run
      #
      # @return [Integer]
      attr_accessor :throttle

      #
      # New DSpace packager
      #
      # @param campus [String]  campus slug
      #
      def initialize(campus)
        # config and loggers
        @campus_slug = campus
        config_file = 'config/packager/' + campus + '.yml'
        @config = OpenStruct.new(YAML.load_file(config_file))
        @log = Packager::Log.new(@config['output_level'])

        raise 'Must set campus name in config' unless @config['campus']

        # set working directories
        @input_dir = @config['input_dir']
        @output_dir = initialize_directory(File.join(@input_dir, 'unpacked'))
        @complete_dir = initialize_directory(File.join(@input_dir, 'complete'))
        @error_dir = initialize_directory(File.join(@input_dir, 'error'))

        @throttle = 0
        @throttle_always = 600 # time to sleep for built-in throttling
        @errors = 0 # error counter

        @log.info 'Starting rake task packager:aip'.green
        @log.info 'Campus: ' + @config['campus'].yellow
      end

      #
      # Process all items
      #
      def process_items
        @log.info 'Processing all items.'

        x = 1
        Dir.foreach(@input_dir) do |filename|
          next unless filename.include?('.zip') && filename.include?('ITEM')

          process_package(filename)
          sleep @throttle unless @throttle.zero?

          # throttle during the day
          x += 1
          if CalState::Metadata.should_throttle(x, 3)
            @log.info 'shhhh sleeping . . . . '
            sleep @throttle_always
          end
        end
      end

      #
      # Process the supplied package from the @input directory
      # unzips the package and processes its contents
      # moves processed zip files to 'complete' or 'error' dirs
      #
      # @param source_file [String]  the .zip file to process
      #
      def process_package(source_file)
        @log.info "\n\nProcessing " + source_file

        begin
          # unzip package and set file working directory
          zip_file = File.join(@input_dir, source_file)
          file_dir = unzip_package(zip_file)

          # no zip file found, so skip it
          return nil if file_dir.nil?

          # process mets file
          process_mets(file_dir)
          File.rename(zip_file, File.join(@complete_dir, source_file))

        rescue Net::ReadTimeout => e
          process_error(e, zip_file, source_file)
          sleep @throttle_always

        rescue ActiveFedora::UnknownAttributeError => e
          process_error(e, zip_file, source_file)
          @errors -= 1 # keep on truckin'

        rescue StandardError => e
          process_error(e, zip_file, source_file)
          sleep 60

        else
          @errors = 0 # success, so reset the counter
        end
      end

      protected

      #
      # Log error and optionally exit
      #
      # @param error [StandardError]
      # @param zip_file [String]      full path to .zip file to process
      # @param source_file [String]   just the .zip file name
      #
      def process_error(error, zip_file, source_file)
        @log.error error.class.to_s.red
        @log.error error
        File.rename(zip_file, File.join(@error_dir, source_file))
        @errors += 1

        # exit if so configured or we got three errors in a row
        raise error if @config['exit_on_error'] || @errors >= 3
      end

      #
      # Extract a .zip file
      # extracted files go to the @output directory
      #
      # @param zip_file [String]  the full path of the zip file
      #
      # @return [String|nil] the full path of the directory created, nil if not found
      #
      def unzip_package(zip_file)
        @log.info 'Unzipping ' + zip_file

        unless File.exist?(zip_file)
          @log.error zip_file + ' not found.'
          return nil
        end

        # create a new directory
        file_dir = File.join(@output_dir, File.basename(zip_file, '.zip'))
        Dir.mkdir file_dir unless Dir.exist?(file_dir)

        # extract contents of zip file
        Zip::File.open(zip_file) do |zipfile|
          zipfile.each do |f|
            fpath = File.join(file_dir, f.name)
            zipfile.extract(f, fpath) unless File.exist?(fpath)
          end
        end

        file_dir
      end

      #
      # Process the METS file in a directory
      # creates new work(s) based on content
      #
      # @param file_dir [String]  the directory of the extracted package
      #
      # @raise RuntimeError if no METS file found
      #
      def process_mets(file_dir)
        @log.info 'Processing METS file'

        # make sure we actually have a mets file
        mets_file = File.join(file_dir, 'mets.xml')
        raise 'No METS file found in ' + file_dir unless File.exist?(mets_file)

        # parse it
        dom = Nokogiri::XML(File.open(mets_file))

        # determine the type of object
        # if this is a dspace item, create a new work
        # otherwise process the items from this community/collection

        type = dom.root.attr('TYPE')

        if ['DSpace COMMUNITY', 'DSpace COLLECTION'].include?(type)
          struct_data = dom.xpath('//mets:mptr', 'mets' => 'http://www.loc.gov/METS/')
          struct_data.each do |file_data|
            if file_data.attr('LOCTYPE') == 'URL'
              process_package(file_data.attr('xlink:href'))
            end
          end
        elsif type == 'DSpace ITEM'
          create_work_and_files(file_dir, dom)
        end
      end

      #
      # Create new work and attach any files
      #
      # @param file_dir [String]              the file working directory
      # @param dom [Nokogiri::XML::Document]  DOMDocument of METS file
      #
      def create_work_and_files(file_dir, dom)
        @log.info 'Ingesting DSpace item'

        start_time = DateTime.now

        # data mapper
        params = collect_params(dom)
        pp params if @debug

        @log.info 'Handle: ' + params['handle'][0]

        @log.info 'Creating Hyrax work...'
        work = create_new_work(params)

        if @config['metadata_only']
          @log.info 'Metadata only'
        else
          @log.info 'Getting uploaded files'
          uploaded_files = get_files_to_upload(file_dir, dom)

          @log.info 'Attaching file(s) to work job...'
          AttachFilesToWorkJob.perform_now(work, uploaded_files)
        end

        # Register work in handle
        HandleRegisterJob.perform_now(work)

        # record the time it took
        end_time = Time.now.minus_with_coercion(start_time)
        total_time = Time.at(end_time.to_i.abs).utc.strftime('%H:%M:%S')
        @log.info 'Total time: ' + total_time
        @log.info 'DONE!'.green
      end

      #
      # Create a new Hyrax work
      #
      # @param params [Hash]  the field/xpath mapper
      #
      # @return [ActiveFedora::Base] the work
      #
      def create_new_work(params)
        @log.info 'Configuring work attributes'

        # set depositor
        depositor = User.find_by_user_key(@config['depositor'])
        raise 'User ' + @config['depositor'] + ' not found.' if depositor.nil?

        # set noid
        id = Noid::Rails::Service.new.minter.mint

        # set resource type
        resource_type = 'Thesis'
        unless params['resource_type'].first.nil?
          resource_type = params['resource_type'].first
        end

        # set campus
        params['campus'] = [@config['campus']]

        # set visibility
        if params.key?('embargo_release_date')
          # indefinite embargo, just make it private
          if params['embargo_release_date'].include?('10000-01-01') ||
             params['embargo_release_date'].empty?
            params['visibility'] = 'restricted'
            params.except!('embargo_release_date')
          else # regular embargo
            params['visibility_after_embargo'] = 'open'
            params['visibility_during_embargo'] = 'authenticated'
          end
        else
          params['visibility'] = 'open'
        end

        # set admin set to deposit into
        unless @config['admin_set_id'].nil?
          params['admin_set_id'] = @config['admin_set_id']
        end

        @log.info 'Creating a new ' + resource_type + ' with id:' + id

        if @config['type_to_work_map'][resource_type].nil?
          raise 'No mapping for ' + resource_type
        end

        model_name = @config['type_to_work_map'][resource_type]

        # create the actual work based on the mapped resource type
        model = Kernel.const_get(model_name)
        work = model.new(id: id)
        work.update(params)
        work.apply_depositor_metadata(depositor.user_key)

        # update permissions to include managers
        work = Packager.add_manager_group(work, @campus_slug)
        work.save

        work
      end

      #
      # Get files to upload
      # extracts file info for bitstream (optionally also thumnail) from METS and
      # creates UploadedFile objects for each
      #
      # @param dom [Nokogiri::XML::Document]  DOMDocument of METS file
      #
      # @return [Array<Hyrax::UploadedFile>]
      #
      def get_files_to_upload(file_dir, dom)
        @log.info 'Figuring out which files to upload'

        uploaded_files = []

        # xpath variables
        premis_ns = { 'premis' => 'http://www.loc.gov/standards/premis' }
        mets_ns = { 'mets' => 'http://www.loc.gov/METS/' }
        checksum_xpath = 'premis:objectCharacteristics/premis:fixity/premis:messageDigest'
        original_name_xpath = 'premis:originalName'

        # loop over the files listed in the METS
        file_md5_list = dom.xpath('//premis:object', premis_ns)
        file_md5_list.each do |fptr|
          # file location info
          file_id = fptr.parent.parent.parent.parent.parent.attr('ID')
          next if file_id.nil?

          flocat_xpath = "//mets:file[@ADMID='" + file_id + "']/mets:FLocat"
          file_location = dom.at_xpath(flocat_xpath, mets_ns)

          # the name of the file in the aip package and its original name
          aip_filename = file_location.attr('xlink:href')
          orig_filename = fptr.at_xpath(original_name_xpath, premis_ns).inner_html

          # type of file
          file_type = file_location.parent.parent.attr('USE')

          case file_type
          when 'THUMBNAIL'
            if @config['include_thumbnail']
              uploaded_file = upload_file(file_dir, orig_filename, aip_filename, 'thumbnail')
              uploaded_files.push(uploaded_file) unless uploaded_file.nil?
            end
          when 'ORIGINAL'
            uploaded_file = upload_file(file_dir, orig_filename, aip_filename, 'bitstream')
            uploaded_files.push(uploaded_file) unless uploaded_file.nil?
          end
        end

        uploaded_files
      end

      #
      # Upload file to Hyrax
      # uses the original file name instead of name given by aip package
      #
      # @param file_dir [String]       the file working directory
      # @param orig_filename [String]  the original file name
      # @param aip_filename [String]   the name given by DSpace AIP export
      # @param type [String]           whether 'thumbnail' or 'bitstream'
      #
      # @return Hyrax::UploadedFile
      #
      def upload_file(file_dir, orig_filename, aip_filename, type)
        @log.info 'Uploading file ' + orig_filename
        @log.info "Renaming #{type} #{aip_filename} -> #{orig_filename}"

        File.rename(file_dir + '/' + aip_filename,
                    file_dir + '/' + orig_filename)
        file = File.open(file_dir + '/' + orig_filename)

        uploaded_file = Hyrax::UploadedFile.create(file: file)
        uploaded_file.save

        file.close

        uploaded_file
      end

      #
      # Extract data from XML based on config data mapping
      #
      # @param dom [Nokogiri::XML::Document]  DOMDocument of METS file
      #
      # @return Hash
      #
      def collect_params(dom)
        params = Hash.new { |h, k| h[k] = [] }

        @config['fields'].each do |field|
          field_name = field[0]
          field_definition = field[1]

          next unless field_definition.include? 'xpath'

          # definition checks
          if field_definition['xpath'].nil?
            raise '"' + field_name + '" defined with empty xpath'
          end
          if field_definition['type'].nil?
            raise '"' + field_name + '" missing type'
          end

          field_definition['xpath'].each do |current_xpath|
            desc_metadata_prefix = '//xmlns:mdWrap[@OTHERMDTYPE="DIM"]/' \
              'xmlns:xmlData/dim:dim[@dspaceType="ITEM"]'
            namespace = {
              xmlns: 'http://www.loc.gov/METS/',
              dim: 'http://www.dspace.org/xmlns/dspace/dim'
            }
            metadata = dom.xpath(desc_metadata_prefix + current_xpath, namespace)

            unless metadata.empty?
              if field_definition['type'].include? 'Array'
                metadata.each do |node|
                  params[field_name] << node.text.squish
                end
              else
                params[field_name] = metadata.text.squish
              end
            end
          end
        end
        params
      end

      #
      # Create a directory
      # only if it doesn't already exist
      #
      # @param dir [String]
      #
      # @return [String] the new directory
      #
      def initialize_directory(dir)
        Dir.mkdir(dir) unless Dir.exist?(dir)
        dir
      end
    end
  end
end
