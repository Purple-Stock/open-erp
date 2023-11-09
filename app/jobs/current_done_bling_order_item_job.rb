# frozen_string_literal: true

class CurrentDoneBlingOrderItemJob < BlingOrderItemCreatorBaseJob
  DONE_STATUSES = [BlingOrderItem::Status::CHECKED, BlingOrderItem::Status::VERIFIED].freeze

  def perform(account_id)
    @alteration_date = Date.today.strftime('%Y-%m-%d')
    options = { dataAlteracaoInicial: alteration_date }
    @account_id = account_id
    begin
      DONE_STATUSES.each do |status|
        orders = Services::Bling::Order.call(order_command: 'find_orders', tenant: account_id,
                                             situation: status, options:)
        orders = orders['data']

        create_orders(orders)
      end
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
