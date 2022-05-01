source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 7.0.0"
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.3', '>= 4.3.12'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6.0.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.3', '>= 4.3.0'
gem 'psych', '< 4'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.11', '>= 2.11.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'devise'

gem "rubycritic", require: false

gem 'net-smtp', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'ffaker'
  gem 'factory_bot_rails'
  gem 'solargraph'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 4.2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 5.0'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

gem 'geared_pagination'
gem 'platform_agent'
gem 'ransack'
gem 'spreadsheet_architect'
group :production do
  gem 'rack-ratelimit'
  gem 'rack-timeout'
  gem 'redis'
  gem 'sidekiq'
end
gem 'httparty'

gem 'nokogiri'

gem 'pagy', '~> 5.10.1'

gem 'business', '~> 2.0'

gem 'acts_as_tenant'

gem 'aws-sdk-s3', require: false
gem 'cocoon'
gem 'jquery-rails'
gem 'jsonapi-serializer'
gem 'rack-cors', require: 'rack/cors'
gem 'rails-i18n', '~> 7.0.0'
gem 'rqrcode_png'
gem 'serviceworker-rails'
