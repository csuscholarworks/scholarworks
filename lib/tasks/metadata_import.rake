# frozen_string_literal: true

require 'calstate/metadata/csv'

# Usage:
# bundle exec rake calstate:metadata_import[eastbay,thesis]

namespace :calstate do
  desc 'Import metadata csv for a campus'
  task :metadata_import, %i[campus model] => [:environment] do |_t, args|
    campus = args[:campus] or raise 'No campus specified.'
    model = args[:model] ||= 'thesis'

    file = "/home/ec2-user/data/import/transactions/#{campus}_#{model}.xml"
    updater = CalState::Metadata::Csv::Updater.new(file, model)
    updater.run
    updater.archive_file
  end
end
