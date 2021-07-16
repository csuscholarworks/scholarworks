# frozen_string_literal: true

require 'csv'

namespace :calstate do
  desc 'Metadata fixer'
  task metadata_fixer: :environment do
    csv_file = '/home/ec2-user/data/remove.csv'
    options = { headers: true, encoding: 'bom|utf-8' }
    x = 0

    CSV.read(csv_file, options).each do |row|
      id = row['hyrax id']
      type = row['model']
      x += 1

      begin
        model = CalState::Metadata.get_model_from_slug(type)
        doc = model.find(id)
        print "\n" + id + ' . . . '

        doc.destroy
        print 'deleted.'
      rescue ActiveFedora::ObjectNotFoundError
        print 'not found.'
      rescue Ldp::HttpError => e
        raise e unless e.message.include?('Cannot locate child node')

        print "couldn't locate child node."
      end

      # throttle
      sleep(60)
      next unless (x % 10).zero?

      print "\n sleeping . . . "
      sleep(300)
      print "wake up! \n"
    end
  end
end
