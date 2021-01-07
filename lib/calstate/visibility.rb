# frozen_string_literal: true

module CalState
  class Visibility
    #
    # New Visibility object
    #
    def initialize
      @visibility_options = check_visibility
    end

    #
    # Set visibility on files
    #
    # @param [ActiveFedora::Base] work   ScholarWorks work
    # @param [String] work_visibility    visibility for work
    # @param [String] file_visibility    visibility for file
    #
    # @return [FalseClass]
    #
    def set_file_visibility(work, work_visibility, file_visibility)
      # this is ugly, but couldn't find a more efficient way to do this,
      # especially for campus visibility which behaves differently

      # set work to new visibility so files can inherit from that
      work.visibility = file_visibility
      work.save
      InheritPermissionsJob.perform_now(work)

      # set work to specified visibility
      work.visibility = work_visibility
      work.save
    end

    #
    # Load input spreadsheet and verify visibility settings
    #
    # @param [String] csv_file  path to csv file
    #
    # @return [Array]
    #
    def get_csv(csv_file)
      x = 0
      rows = []
      csv = CSV.read(csv_file, headers: true)
      csv.each do |row|
        x += 1
        unless @visibility_options.include? row['work_visibility']
          raise 'Row ' + x.to_s + ' of ' + csv_file +
                ' contains invalid visibility option: ' + row['work_visibility']
        end
        rows << row
      end
      rows
    end

    private

    #
    # Get the visibility option from AccessControls
    #
    # @return [Array]
    #
    def check_visibility
      options = []
      Hydra::AccessControls::AccessRight.constants(false).each do |c|
        if c.to_s.include? 'VISIBILITY'
          options.append Hydra::AccessControls::AccessRight.const_get c
        end
      end
      options
    end
  end
end