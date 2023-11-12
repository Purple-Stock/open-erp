# frozen_string_literal: true

class PendingOrderItemsJob < BlingOrderItemCreatorBaseJob
  queue_as :default
  STATUS = BlingOrderItem::Status::PENDING.freeze

  attr_accessor :account_id

  def perform(account_id)
    @status = STATUS
    @account_id = account_id
    begin
      orders = Services::Bling::Order.call(order_command: 'find_orders', tenant: account_id,
                                           situation: @status)
      orders = orders['data']

      create_orders(orders)
    rescue StandardError => e
      Rails.logger.error(e.message)
    end
  end
end
