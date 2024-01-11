# frozen_string_literal: true

class StockSyncJob < ApplicationJob
  queue_as :default
  rescue_from(StandardError) do |exception|
    Sentry.capture_message(exception)
  end

  retry_on StandardError, wait: :exponentially_longer, attempts: 5

  def perform(tenant, options = {})
    Product.find_in_batches(batch_size: 50) do |product_group|
      bling_product_ids = product_group.pluck(:bling_id)
      Stock.synchronize_bling(tenant, bling_product_ids)
    end
  end
end
