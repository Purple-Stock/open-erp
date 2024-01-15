# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.after_initialize do
    Bullet.enable        = true
    Bullet.alert         = true
    Bullet.bullet_logger = true
    Bullet.console       = true
    Bullet.rails_logger  = true
    Bullet.add_footer    = true
  end

  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true
  config.good_job.smaller_number_is_higher_priority = true

  config.good_job.enable_cron = ENV['ENABLE_CRON'] || false
  config.good_job.cron = {
    product_sync_job: {
      cron: "*/60 * * * *",
      class: "ProductSyncJob",
      args: [1],
      set: { priority: 1 },
      description: "Synchronize products"
    },

    stock_sync_job: {
      cron: "*/10 * * * *",
      class: "StockSyncJob",
      args: [1],
      set: { priority: 1 },
      description: "Synchronize Stocks based in products already created"
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
    },

    collected_order_items_task: {
      cron: "*/5 * * * *",
      class: "CollectedBlingOrderItemsJob",
      args: [1, (Date.today - 5.days)],
      set: { priority: 4 },
      description: "Create Order Items whose statuses are collected"
    }
  }
end
