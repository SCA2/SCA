# This file is copied to spec/ when you run 'rails generate rspec:install'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'factory_bot_rails'

require 'simplecov'
SimpleCov.start 'rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("app/helpers/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  # Infer spec type from directory name
  config.infer_spec_type_from_file_location!

  # Force expect syntax
  config.expect_with :rspec do |c| c.syntax = :expect end

  # Include Factory Bot syntax to simplify calls to factories
  config.include FactoryBot::Syntax::Methods

  # Include rails url helpers
  config.include Rails.application.routes.url_helpers

  # Include sessions helpers in tests
  config.include SessionsHelper

  config.include Capybara::DSL
  
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # Database cleaner
  config.before(:suite)           { DatabaseCleaner.clean_with(:truncation) }
  config.before(:each)            { DatabaseCleaner.strategy = :transaction }
  config.before(:each, js: true)  { DatabaseCleaner.strategy = :truncation }
  config.before(:each)            { DatabaseCleaner.start }
  config.after(:each)             { DatabaseCleaner.clean }


  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  
  config.include(MailerMacros)
  config.before(:each) { reset_email }
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    args: %w[headless disable-gpu no-sandbox]
  )
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.javascript_driver = :headless_chrome
