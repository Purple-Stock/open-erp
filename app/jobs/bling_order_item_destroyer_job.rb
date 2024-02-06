class BlingOrderItemDestroyerJob < ApplicationJob
  def perform(bling_order_id)
    order = BlingOrderItem.find_by(bling_order_id:)
    return unless order.not_found_at_bling?

    order.update(situation_id: BlingOrderItemStatus::DELETED_AT_BLING)
  end
end
