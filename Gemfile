source 'https://rubygems.org'
ruby '2.1.3'

gem 'rails'
gem 'foundation-rails'
gem 'bcrypt-ruby'
gem 'will_paginate'
gem 'will_paginate-foundation'


group :development, :test do
  gem 'autotest-rails', '~> 4.2.1'
  gem 'rspec-rails', '~> 2.14.0'
  gem 'cucumber-rails', '~> 1.4.1', :require => false
  gem 'rails_layout'
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'byebug'
end

group :test do
  gem 'faker', '~> 1.2.0'
  gem 'capybara', '~> 2.1.0'
  gem 'database_cleaner', '~> 1.0.1'
  gem 'selenium-webdriver', '~> 2.39.0'
  gem 'launchy', '~> 2.3.0'
end

group :production do
  gem 'rails_12factor'
end

gem 'pg'
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'jbuilder'
#gem 'activemerchant', '~> 1.42.7'
gem 'active_shipping'
gem 'roadie'
gem 'carmen-rails'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'activemerchant', '1.44.1',
  :path => 'vendor/gems/activemerchant-1.44.1',
  :require => 'active_merchant'
gem 'active_utils', '2.2.3',
  :path => 'vendor/gems/active_utils-2.2.3'