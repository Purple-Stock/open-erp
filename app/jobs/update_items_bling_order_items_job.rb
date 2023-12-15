class UpdateItemsBlingOrderItemsJob < ApplicationJob
  queue_as :default

  def perform(store_id, situation_id, current_tenant_id)
    bling_order_ids = BlingOrderItem.where(store_id: store_id, situation_id: situation_id, items: nil).pluck(:bling_order_id)
    Services::Bling::FindOrders.call(order_command: 'find_orders', tenant: current_tenant_id, ids: bling_order_ids) 
  end
end
