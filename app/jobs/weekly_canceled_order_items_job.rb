# frozen_string_literal: true

# WeeklyCanceledOrderItemJob
# As the store increase its purchases, it is more often many canceling status appearing
# Every status can jump from itself to canceled status.
# Canceled status accumulates quantities and do not revert to its previous status.
# As the time passes, requesting canceled status using our api leads to error TOO_MANY_REQUESTS from bling API.
# Weekly jobs will execute more often than general jobs.
# The more actual is a order purchase the more often we want it to be up to date.
class WeeklyCanceledOrderItemsJob < BlingOrderItemCreatorBaseJob
  queue_as :default

  STATUS = BlingOrderItem::Status::CANCELED.freeze

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
