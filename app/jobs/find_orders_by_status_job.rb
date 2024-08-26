require 'retryable'

class ImprovedFindOrdersByStatusJob < ApplicationJob
  queue_as :default

  MAX_RETRIES = 3
  RETRY_DELAY = 5 # seconds

  def perform(status, tenant_id)
    orders = BlingOrderItem.where(account_id: tenant_id, situation_id: status)
    bling_datum = BlingDatum.find_by(account_id: tenant_id)

    if bling_datum.nil?
      Rails.logger.error("No BlingDatum found for account_id: #{tenant_id}")
      return
    end

    orders.find_each do |order|
      process_order(order, tenant_id)
    end
  end

  private

  def process_order(order, tenant_id)
    Retryable.retryable(
      tries: MAX_RETRIES,
      sleep: RETRY_DELAY,
      on: [StandardError],
      matching: /TOO_MANY_REQUESTS/,
      exception_cb: Proc.new { |exception|
        Rails.logger.warn("Retrying after TOO_MANY_REQUESTS error for order #{order.bling_order_id}. #{exception.message}")
      }
    ) do
      result = Services::Bling::FindOrder.call(
        id: order.bling_order_id,
        order_command: 'find_order',
        tenant: tenant_id
      )

      if result.is_a?(Hash) && result['data'].present?
        update_order(order, result['data'])
      elsif result.is_a?(Hash) && result['error'].present? && result['error']['type'] == 'RESOURCE_NOT_FOUND'
        delete_order(order)
      else
        Rails.logger.error("Failed to fetch order #{order.bling_order_id}: #{result}")
        raise StandardError, result['error']['message'] if result.is_a?(Hash) && result['error'].present?
      end
    end
  rescue StandardError => e
    Rails.logger.error("Failed to process order #{order.bling_order_id} after #{MAX_RETRIES} retries: #{e.message}")
  end

  def update_order(order, data)
    order_data = data['pedido'] || data

    if order_data.is_a?(Hash) && order_data['situacao'].is_a?(Hash)
      order.update!(
        situation_id: order_data['situacao']['id'].to_s,
        date: order_data['data'],
        value: order_data['total'],
        # Add more fields as needed
      )
      Rails.logger.info("Successfully updated order #{order.bling_order_id}")
    else
      Rails.logger.error("Invalid order data for order #{order.bling_order_id}: #{order_data}")
    end
  rescue StandardError => e
    Rails.logger.error("Failed to update order #{order.bling_order_id}: #{e.message}")
  end

  def delete_order(order)
    order.destroy
    Rails.logger.info("Deleted order #{order.bling_order_id} as it was not found in Bling API")
  rescue StandardError => e
    Rails.logger.error("Failed to delete order #{order.bling_order_id}: #{e.message}")
  end
end