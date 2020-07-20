# config/initializers/willow_sword.rb
# Overriding the default config values
WillowSword.setup do |config|
  config.work_models = %w[Dataset EducationalResource Publication Thesis]
end