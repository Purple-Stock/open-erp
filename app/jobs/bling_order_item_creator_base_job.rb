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

    create_orders_attributes = []
    update_orders_attributes = []

    orders.each do |order|
      if query_bling_order_ids.include?(order['id'])
        update_orders_attributes << {
          bling_order_id: order['id'],
          situation_id: order['situacao']['id'],
          store_id: order['loja']['id'],
          date: order['data'],
          alteration_date:,
          marketplace_code_id: order['numeroLoja'],
          bling_id: order['numero'],
          account_id:,
          value: order['total']
        }
      else
        create_orders_attributes << {
          bling_order_id: order['id'],
          situation_id: order['situacao']['id'],
          store_id: order['loja']['id'],
          date: order['data'],
          alteration_date:,
          marketplace_code_id: order['numeroLoja'],
          bling_id: order['numero'],
          account_id:,
          value: order['total']
        }
      end
    end

    BlingOrderItem.create(create_orders_attributes)

    update_orders_attributes.each do |update_attribute|
      BlingOrderItem.find_by(bling_order_id: update_attribute[:bling_order_id]).update(update_attribute)
    end
  end
end
