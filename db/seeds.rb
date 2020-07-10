# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

admin = User.where(email: 'kcloud@calstate.edu').first_or_create do |u|
  u.password = 'testing123'
  u.password_confirmation = 'testing123'
  u.admin_area = true
end
role = Role.where(name: 'admin').first_or_create
role.users << admin unless role.users.include?(admin)
role.save!

puts "created admin user #{admin}"

Hyrax::CampusService::CAMPUSES.each do |campus|

  campus_admin_set = AdminSet.where(title: campus[:name]).first
  if campus_admin_set.blank?
    puts "Creating #{campus[:name]} AdminSet"
    campus_admin_set = AdminSet.create!(title: [campus[:name]]) unless campus_admin_set.present?
  else
    puts "#{campus[:name]} AdminSet already exists"
  end
  Hyrax::AdminSetCreateService.call(admin_set: campus_admin_set, creating_user: admin)
  campus_user_email = "user@#{campus[:email_domains].first}"
  puts "Creating user #{campus_user_email}"
  user = User.where(email: campus_user_email).first_or_create do |f|
    f.password = 'testing123'
    f.password_confirmation = 'testing123'
    f.admin_area = true
  end

  puts "Adding #{campus_user_email} to #{campus[:name]} AdminSet"
  campus_admin_set.edit_users << user
  campus_admin_set.save!
end
