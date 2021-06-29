
# frozen_string_literal: true

require 'calstate/metadata'

# Usage:
# bundle exec rake calstate:metadata_transaction[eastbay,thesis]

namespace :calstate do
  desc 'Import metadata csv for a campus'
  task :metadata_transaction, %i[campus model] => [:environment] do |_t, args|
    campus = args[:campus] or raise 'No campus specified.'
    model = args[:model] or raise 'No model specified.'

    old_dir = '/home/ec2-user/data/exported'
    new_dir = '/home/ec2-user/data/import'
    transaction_dir = new_dir + '/transactions'
    report_dir = '/mnt/efs2/exports/reports/'

    trans = CalState::Metadata::Csv::Transaction.new(campus, model, old_dir, new_dir)

    # create transaction file
    File.write("#{transaction_dir}/#{campus}_#{model}.xml", trans.to_xml)

    # create html report
    File.write("#{report_dir}/#{campus}_#{model}.html", trans.to_html)
  end
end
