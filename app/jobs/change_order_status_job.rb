class ChangeOrderStatusJob < ApplicationJob
  attr_accessor :account_id

  def perform(old_status, new_status, account_id)
    orders = Services::Bling::Order.call(order_command: 'find_orders', tenant: account_id,
                                         situation: old_status)
    orders = orders['data']

    orders_ids = []
    orders.each do |order|
      orders_ids << order['id'].to_s
    end

    Services::Bling::UpdateOrderStatus.call(
      tenant: account_id,
      order_ids: orders_ids,
      new_status:
    )
  end
end
