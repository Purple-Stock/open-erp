# frozen_string_literal: true

class ProductSyncJob < ApplicationJob
  queue_as :default
  rescue_from(StandardError) do |exception|
    Sentry.capture_message(exception)
  end

  retry_on StandardError, wait: :exponentially_longer, attempts: 5

  def perform(tenant, options = {})
    Product.synchronize_bling(tenant, options)
  end
end
