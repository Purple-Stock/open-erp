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
end
