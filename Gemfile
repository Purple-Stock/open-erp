source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# dotenv-rails must be on the top
gem 'dotenv-rails', groups: %i[development test]

gem 'inherited_resources', '1.14.0'

# Bundle Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 7.1.0"
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.0", ">= 6.0.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails", ">= 1.2.0"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails", ">= 1.5.0"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails", ">= 1.3.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

gem 'devise'

gem "rubycritic", require: false

gem 'net-smtp', require: false

gem 'csv-importer'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-byebug'
  gem 'rspec-rails', '>= 6.0.2'
  gem 'faker'
  gem 'factory_bot_rails'
  gem 'solargraph'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 4.2.1'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring

  gem 'spring', '~> 3.0.0'
  # gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'

end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem 'shoulda-matchers', '~> 5.3', '>= 5.3.0'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'simplecov', '~> 0.21.2'
  gem 'vcr'
  gem 'webmock'
end

group :production do
#   gem 'rack-ratelimit'
#   gem 'rack-timeout'

  #gem 'sidekiq', '>= 7.1.3'
end

gem 'geared_pagination'
gem 'platform_agent'
gem 'ransack'
gem 'spreadsheet_architect'

gem 'httparty', '>= 0.21.0'

gem 'nokogiri'

gem 'pagy', '~> 6.0.0'

gem 'business', '~> 2.0'

gem 'acts_as_tenant'

gem 'aws-sdk-s3', require: false
gem 'cocoon'
# gem 'jquery-rails'
gem 'jsonapi-serializer'
gem 'rack-cors', require: 'rack/cors'
gem 'rails-i18n', '~> 7.0.8'
gem 'rqrcode_png', git: "https://github.com/DCarper/rqrcode_png.git"
gem 'serviceworker-rails'
gem 'rubocop-rails', '>= 2.21.2', require: false
gem 'rubocop-rspec', require: false
gem 'rubocop-performance', require: false
gem 'bling_api', git: 'https://github.com/Purple-Stock/bling_api'

gem "good_job", "~> 3.19", ">= 3.19.1"

gem 'roo'
gem 'roo-xls'
gem 'activerecord-import'