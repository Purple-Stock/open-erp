# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in either ENV["RAILS_MASTER_KEY"]
  # or in config/master.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress CSS using a preprocessor.
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Mount Action Cable outside main process or domain.
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_cable.allowed_request_origins = [ "http://example.com", /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Include generic and useful information about system operation, but avoid logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII).
  config.log_level = :info

  # Prepend all log lines with the following tags.
  config.log_tags = [:request_id]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment).
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "awesome_rails_production"
  config.active_job.queue_adapter = :async
  # config.action_controller.asset_host = ENV['CLOUDFRONT_URL']
  config.cache_store = :redis_cache_store, { url: ENV['REDISCLOUD_URL'] }

  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require "syslog/logger"
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new "app-name")

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  config.good_job.enable_cron = false
  config.good_job.cron = {
    product_sync_job: {
      cron: "*/10 * * * *",
      class: "ProductSyncJob",
      args: [1],
      set: { priority: 1 },
      description: "Synchronize products"
    },

    in_progress_order_items_task: { # each recurring job must have a unique key
                                    cron: "*/2 * * * *", # cron-style scheduling format by fugit gem
                                    class: "InProgressOrderItemsJob", # name of the job class as a String; must reference an Active Job job class
                                    args: [1], # positional arguments to pass to the job; can also be a proc e.g. `-> { [Time.now] }`
                                    set: { priority: 1 }, # additional Active Job properties; can also be a lambda/proc e.g. `-> { { priority: [1,2].sample } }`
                                    description: "Create Order Items with status in progress" # optional description that appears in Dashboard
    },

    weekly_pending_order_items_task: {
      cron: "*/4 * * * *",
      class: "PendingOrderItemsJob",
      args: [1, { dataInicial: (Date.today - 3.weeks).strftime, dataFinal: Date.today.strftime }],
      set: { priority: 1 },
      description: "Create Order Items with pending status from current week"
    },

    general_pending_order_items_task: {
      cron: "@monthly",
      class: "PendingOrderItemsJob",
      args: [1],
      set: { priority: 1 },
      description: "Create Order Items with pending status considering all period"
    },

    printed_order_items_task: { # each recurring job must have a unique key
                                cron: "*/2 * * * *", # cron-style scheduling format by fugit gem
                                class: "PrintedOrderItemsJob", # name of the job class as a String; must reference an Active Job job class
                                args: [1], # positional arguments to pass to the job; can also be a proc e.g. `-> { [Time.now] }`
                                set: { priority: 1 }, # additional Active Job properties; can also be a lambda/proc e.g. `-> { { priority: [1,2].sample } }`
                                description: "Create Order Items with printed status" # optional description that appears in Dashboard
    },

    current_done_order_items_task: { # each recurring job must have a unique key
                                     cron: "*/2 * * * *", # cron-style scheduling format by fugit gem
                                     class: "CurrentDoneBlingOrderItemJob", # name of the job class as a String; must reference an Active Job job class
                                     args: [1], # positional arguments to pass to the job; can also be a proc e.g. `-> { [Time.now] }`
                                     set: { priority: 1 }, # additional Active Job properties; can also be a lambda/proc e.g. `-> { { priority: [1,2].sample } }`
                                     description: "Create Order Items statuses are checked and verified" # optional description that appears in Dashboard
    },
    general_canceled_order_items_task: { # each recurring job must have a unique key
                                         cron: "@monthly", # cron-style scheduling format by fugit gem
                                         class: "CanceledBlingOrderItemsJob", # name of the job class as a String; must reference an Active Job job class
                                         args: [1], # positional arguments to pass to the job; can also be a proc e.g. `-> { [Time.now] }`
                                         set: { priority: 1 }, # additional Active Job properties; can also be a lambda/proc e.g. `-> { { priority: [1,2].sample } }`
                                         description: "Create Order Items statuses are canceled" # optional description that appears in Dashboard
    },

    weekly_canceled_order_items_task: { # each recurring job must have a unique key
                                        cron: "*/4 * * * *", # cron-style scheduling format by fugit gem
                                        class: "WeeklyCanceledOrderItemsJob", # name of the job class as a String; must reference an Active Job job class
                                        args: [1, { dataInicial: 3.weeks.ago.to_date.strftime, dataFinal: Date.today.strftime }], # positional arguments to pass to the job; can also be a proc e.g. `-> { [Time.now] }`
                                        set: { priority: 1 }, # additional Active Job properties; can also be a lambda/proc e.g. `-> { { priority: [1,2].sample } }`
                                        description: "Create Order Items statuses are canceled" # optional description that appears in Dashboard
    },

    daily_canceled_order_task: {
      cron: "*/10 * * * *",
      class: "DailyCanceledOrderJob",
      args: [1, Date.today],
      set: { priority: 1 },
      description: "Create Order Items statuses are canceled at current day"
    },

    checked_order_items_task: {
      cron: "@weekly",
      class: "CheckedBlingOrderItemsJob",
      args: [1],
      set: { priority: 3 },
      description: "Create Order Items statuses are checked"
    },

    frequent_checked_order_items_task: {
      cron: "*/2 * * * *",
      class: "CheckedBlingOrderItemsJob",
      args: [1, (Date.today - 5.days)],
      set: { priority: 1 },
      description: "Create Order Items statuses are checked"
    },

    verified_order_items_task: {
      cron: "@weekly",
      class: "VerifiedBlingOrderItemsJob",
      args: [1],
      set: { priority: 4 },
      description: "Create Order Items whose statuses are verified"
    }
    # etc.
  }
end
