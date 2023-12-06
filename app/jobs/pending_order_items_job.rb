# frozen_string_literal: true

class PendingOrderItemsJob < BlingOrderItemCreatorBaseJob
  queue_as :default

  STATUS = BlingOrderItem::Status::PENDING.freeze

  attr_accessor :account_id

  def perform(account_id, options = {})
    @status = STATUS
    @account_id = account_id

    orders = Services::Bling::Order.call(order_command: 'find_orders', tenant: account_id,
                                         situation: @status, options: options)
    orders = orders['data']

    create_orders(orders)
  end
end
