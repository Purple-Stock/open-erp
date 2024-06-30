source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# dotenv-rails must be on the top
gem 'dotenv-rails', '>= 3.0.0', groups: %i[development test]

gem 'inherited_resources', '1.14.0'

# Bundle Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 7.0.8", ">= 7.0.8.4"
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails", ">= 3.5.1"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.4", ">= 6.4.2"

# For police pattern
gem 'pundit'

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails", ">= 1.3.0"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails", ">= 2.0.0"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails", ">= 1.3.1"

gem "sentry-ruby"
gem "sentry-rails", ">= 5.16.1"

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
gem "image_processing", "~> 1.2"

gem 'devise', '>= 4.9.4'

# for decorator pattern https://github.com/drapergem/draper
gem 'draper'

gem 'enumerate_it'

gem 'factory_bot_rails', '>= 6.4.2'

gem 'faker'

gem "rubycritic", require: false

gem 'net-smtp', require: false

gem 'csv-importer'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'bullet'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-byebug'
  gem 'rspec-rails', '>= 6.0.4'
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
  gem "selenium-webdriver", ">= 4.11.0"
  gem "webdrivers"
  gem 'shoulda-matchers', '~> 5.3', '>= 5.3.0'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'simplecov', '~> 0.21.2'
  gem 'vcr'
  gem 'webmock', '>= 3.20.0'
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

gem 'newrelic_rpm'

gem 'pagy', '~> 6.0.0'

gem 'business', '~> 2.0'

gem 'acts_as_tenant', '>= 1.0.0'

gem 'aws-sdk-s3', require: false
gem 'cocoon'
# gem 'jquery-rails'
gem 'jsonapi-serializer'
gem 'rack-cors', require: 'rack/cors'
gem 'rails-i18n', '~> 7.0.9'
gem 'rqrcode_png', git: "https://github.com/DCarper/rqrcode_png.git"
gem 'serviceworker-rails'
gem 'rubocop-rails', '>= 2.25.1', require: false
gem 'rubocop-rspec', '>= 2.24.1', require: false
gem 'rubocop-performance', '>= 1.20.0', require: false
gem 'bling_api', git: 'https://github.com/Purple-Stock/bling_api'

gem "good_job", github: 'bensheldon/good_job', branch: 'main'

gem 'roo'
gem 'roo-xls'
gem 'activerecord-import'
gem 'appsignal', '>= 3.7.6'

gem 'rubyzip'