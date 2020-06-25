# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Hyrax::CampusService::CAMPUSES.each do |campus|
  admin_set = AdminSet.create!(title: [campus])


end
