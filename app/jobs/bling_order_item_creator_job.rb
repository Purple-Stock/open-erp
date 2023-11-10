class BlingOrderItemCreatorJob < BlingOrderItemCreatorBaseJob
  def perform(account_id)
    @account_id = account_id
    list_status_situation.each do |status|
      orders = Services::Bling::Order.call(order_command: 'find_orders', tenant: account_id,
                                           situation: status)
      orders = orders['data']
      next if orders.blank?

      create_orders(orders)
    end
  end

  def list_status_situation
    BlingOrderItem::Status::ALL
  end

  def create_orders(orders)
    orders_attributes = []

    orders.each do |order|
      orders_attributes << {
        bling_order_id: order['id'],
        situation_id: order['situacao']['id'],
        store_id: order['loja']['id'],
        date: order['data'],
        alteration_date:
      }
    end

    BlingOrderItem.upsert_all(orders_attributes, unique_by: :bling_order_id)
  end
end
