source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use Passenger as the app server
# gem 'passenger',">= 5.0.25", require: "phusion_passenger/rack_handler"
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'awesome_print'
gem 'table_print'

# Use sidekiq for background jobs in production
group :production do
  gem 'sidekiq'
end

group :test do
  gem 'rspec-sidekiq'
  gem 'database_cleaner'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'factory_bot_rails'
  gem 'dotenv-rails', require: 'dotenv/rails-now'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'hyrax', '2.5.1'
gem 'hydra-role-management'
gem 'config'

group :development, :test do
  gem 'solr_wrapper', '>= 0.3'
end

gem 'rsolr', '>= 1.0'
gem 'jquery-rails'
gem 'devise', '>= 4.4.0'
gem 'devise-guests', '~> 0.6'
group :development, :test do
  gem 'fcrepo_wrapper'
  gem 'rspec-rails'
end

gem 'riiif', '~> 1.1'
gem 'solargraph'
gem 'colorize'
gem 'rubyzip'
gem "ruby-vips", "~> 2.0"
gem 'diffy'
gem 'handle-system-rest'
gem 'aws-sdk-s3'
gem 'blacklight_oai_provider'
gem 'willow_sword', github: 'csuscholarworks/willow_sword', branch: 'scholarworks'
