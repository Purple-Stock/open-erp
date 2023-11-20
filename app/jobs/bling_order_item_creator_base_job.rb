# frozen_string_literal: true

class BlingOrderItemCreatorBaseJob < ApplicationJob
  queue_as :default
  attr_accessor :account_id, :alteration_date

  def list_status_situation
    BlingOrderItem::Status::ALL
  end

  def fetch_order_data(order_id)
    Services::Bling::FindOrder.call(id: order_id, order_command: 'find_order',
                                    tenant: account_id)
  end

  def create_orders(orders)
    return if orders.blank?

    order_ids = orders.map { |order| order['id'] }
    query_bling_order_ids = BlingOrderItem.select(:bling_order_id).where(bling_order_id: order_ids)
                                          .map { |order| order.bling_order_id.to_i }

    orders_attributes = []
    BlingOrderItem.where(bling_order_id: [query_bling_order_ids])
                  .update_all(situation_id: @status, alteration_date: @alteration_date)

    orders.each do |order|
      next if query_bling_order_ids.include?(order['id'])

      orders_attributes << {
        bling_order_id: order['id'],
        situation_id: order['situacao']['id'],
        store_id: order['loja']['id'],
        date: order['data'],
        alteration_date:,
        marketplace_code_id: order['numeroLoja'],
        bling_id: order['numero']
      }
    end

    BlingOrderItem.create(orders_attributes)
  end
end