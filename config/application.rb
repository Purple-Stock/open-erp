# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AwesomeRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.app                            = config_for(:config)
    config.i18n.default_locale            = :"pt-BR"
    config.i18n.available_locales         = [:default, :"pt-BR", :en ] # added :default option here to appear in the dropdown language switch
    config.time_zone                      = 'America/Sao_Paulo'
    config.generators.scaffold_stylesheet = false

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.management_api = config_for(:management_api)
  end
end