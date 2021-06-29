# frozen_string_literal: true

namespace :calstate do
  desc 'Attach a file to an existing record'
  task attach_file: :environment do
    filename = '/home/ec2-user/data/some-file.mp4'
    id = '000000000'

    file = File.open(filename)
    uploaded_file = Hyrax::UploadedFile.create(file: file)
    uploaded_file.save

    work = Publication.find(id)
    depositor = User.find_by_user_key('kcloud@calstate.edu')
    work.apply_depositor_metadata(depositor.user_key)

    AttachFilesToWorkJob.perform_now(work, [uploaded_file])
  end
end
