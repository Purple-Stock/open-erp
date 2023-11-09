# frozen_string_literal: true

class PendingOrderItemsJob < BlingOrderItemCreatorBaseJob
  queue_as :default
  STATUS = BlingOrderItem::Status::PENDING.freeze

  attr_accessor :account_id

  def perform(account_id)
    @account_id = account_id
    begin
      orders = Services::Bling::Order.call(order_command: 'find_orders', tenant: account_id,
                                           situation: STATUS)
      orders = orders['data']

      create_orders(orders)
    rescue StandardError => e
      Rails.logger.error(e.message)
    end
  end

  def create_orders(orders)
    return if orders.blank?

    order_ids = orders.map { |order| order['id'] }
    query_bling_order_ids = BlingOrderItem.where(bling_order_id: order_ids)
                                          .pluck(:bling_order_id)
                                          .map(&:to_i)


    orders_attributes = []
    BlingOrderItem.where(bling_order_id: [query_bling_order_ids])
                  .update_all(situation_id: STATUS)

    orders.each do |order|
      next if query_bling_order_ids.include?(order['id'])

      orders_attributes << {
        bling_order_id: order['id'],
        situation_id: order['situacao']['id'],
        store_id: order['loja']['id'],
        date: order['data'],
        alteration_date:
      }
    end

    BlingOrderItem.create(orders_attributes)
  end
end
