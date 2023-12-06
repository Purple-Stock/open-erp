# frozen_string_literal: true

class PendingOrderItemsJob < BlingOrderItemCreatorBaseJob
  queue_as :default
  retry_on StandardError, wait: :exponentially_longer, attempts: 5

  STATUS = BlingOrderItem::Status::PENDING.freeze

  attr_accessor :account_id

  def perform(account_id, options = {})
    @status = STATUS
    @account_id = account_id
    begin
      orders = Services::Bling::Order.call(order_command: 'find_orders', tenant: account_id,
                                           situation: @status, options: options)
      orders = orders['data']

      create_orders(orders)
    rescue StandardError => e
      Rails.logger.error(e.message)
    end
  end
end
