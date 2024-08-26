require 'retryable'

class UpdateBlingOrderStatusJob < ApplicationJob
  queue_as :default

  MAX_RETRIES = 3
  RETRY_DELAY = 5 # seconds

  def perform(current_status, new_status, tenant_id, batch_size = 100)
    Rails.logger.info("Starting to update orders from status #{current_status} to #{new_status} for account #{tenant_id}")

    BlingOrderItem.where(account_id: tenant_id, situation_id: current_status)
                  .find_in_batches(batch_size: batch_size) do |batch|
      update_batch(batch, new_status, tenant_id)
    end

    Rails.logger.info("Finished updating orders for account #{tenant_id}")
  end

  private

  def update_batch(batch, new_status, tenant_id)
    order_ids = batch.map(&:bling_order_id)

    Retryable.retryable(
      tries: MAX_RETRIES,
      sleep: RETRY_DELAY,
      on: [StandardError],
      matching: /TOO_MANY_REQUESTS/,
      exception_cb: Proc.new { |exception|
        Rails.logger.warn("Retrying after error: #{exception.message}")
      }
    ) do
      result = Services::Bling::UpdateOrderStatus.call(
        tenant: tenant_id,
        order_ids: order_ids,
        new_status: new_status
      )

      process_results(result[:results], batch, new_status)
    end
  rescue StandardError => e
    Rails.logger.error("Failed to update batch after #{MAX_RETRIES} retries: #{e.message}")
  end

  def process_results(results, batch, new_status)
    results.each do |result|
      order = batch.find { |o| o.bling_order_id == result[:order_id] }
      if result[:status] == 'success'
        update_local_order(order, new_status)
      else
        Rails.logger.error("Failed to update order #{result[:order_id]}: #{result[:error]}")
      end
    end
  end

  def update_local_order(order, new_status)
    old_status = order.situation_id
    order.update!(situation_id: new_status)
    Rails.logger.info("Updated order #{order.bling_order_id} status from #{old_status} to #{new_status}")
  rescue StandardError => e
    Rails.logger.error("Failed to update local order #{order.bling_order_id}: #{e.message}")
  end
end