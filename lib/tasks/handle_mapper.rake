# frozen_string_literal: true

require 'calstate/metadata'

# Usage:
# rm /home/ec2-user/data/handles/*.conf
# bundle exec rake calstate:handles

namespace :calstate do
  desc 'Create a rewrite map of handles to hyrax ids'
  task handles: :environment do
    CalState::Metadata::HandleMapper.new('/home/ec2-user/data/handles').run
  end
end
