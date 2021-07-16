# frozen_string_literal: true

require 'nokogiri'

module CalState
  module Metadata
    module Csv
      #
      # CSV Updater
      #
      class Updater
        include Utilities
        include Metadata::Utilities

        #
        # CSV Updater
        #
        # @param path [String]   path to transaction xml file
        # @param model [String]  model name
        #
        def initialize(path, model)
          @path = path
          @doc = Nokogiri::XML(File.open(path))
          @single_fields = %w[date_accessioned
                              date_modified
                              degree_level
                              embargo_release_date
                              visibility
                              visibility_during_embargo
                              visibility_after_embargo]
          @model = CalState::Metadata.get_model_from_slug(model)
        end

        #
        # Process the transaction file
        #
        def run
          x = 0
          records = @doc.xpath("//record[@complete = 'false']")
          records.each do |record|
            # throttle
            x += 1
            if (x % 25).zero?
              puts 'shhh, sleeping . . . '
              sleep(180)
            end

            # update record
            print "Updating #{record['id']} . . . "
            update_record(record)
            print "done!\n"
          end
        end

        #
        # Move the finished transaction file to archive
        #
        # renames file to include the timestamp
        #
        def archive_file
          timestamp = @doc.xpath('//timestamp').first.content
          new_path = @path.gsub('.xml', '_' + timestamp + '.xml')
          File.rename(@path, new_path)
        end

        #
        # Find and update the record
        #
        # @param record [Hash]  record from the CSV file
        #
        def update_record(record)
          doc = @model.find(record['id'].to_s)

          record.xpath('change').each do |change|
            field = change['field']
            doc[field] = get_value(field, change)
          end

          doc.save

          # mark as processed
          record['complete'] = 'true'
          File.write(@path, @doc.to_xml)
        end

        #
        # Extract the value(s) from the change node
        #
        # @param field [String]          field name
        # @param change [Nokogiri::XML]  node
        #
        # @return [Array|String]
        #
        def get_value(field, change)
          values = []
          if change.xpath('value/part').count.positive?
            change.xpath("value[@type='new']/part").each do |part|
              values.append part.text.squish
            end
          else
            values.append change.xpath("value[@type='new']").first.text
          end

          if @single_fields.include?(field)
            values.first
          else
            values
          end
        end
      end
    end
  end
end
