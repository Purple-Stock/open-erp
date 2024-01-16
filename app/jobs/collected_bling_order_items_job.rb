# frozen_string_literal: true

# CollectedOrderItemsJob perform against created orders set previously
# with another status, such as CHECKED.
# For this reason, we should call this job as an updater job.
# The crucial difference here is the absence of the alteration date in the bling API response.
# It is possible to filter by alteration date, however the alteration date (dataAlteraçãoInicial) is not
# present in the response. Our solution is querying by alteration date assuming it is the same in bling API
# setting this assumed value directly on our database.
class CollectedBlingOrderItemsJob < BlingOrderItemCreatorBaseJob
  STATUS = BlingOrderItem::Status::COLLECTED.freeze

  queue_as :collected_order

  attr_accessor :account_id

  def perform(account_id, initial_alteration_date = nil)
    @status = STATUS
    @account_id = account_id
    @initial_date = initial_alteration_date || Date.today - 3.months
    @final_date = Date.today
    date_range = (@initial_date..@final_date)
    date_range.each do |alteration_date|
      @collected_alteration_date = alteration_date
      final_alteration_date = (alteration_date + 1.day).strftime
      options = { dataAlteracaoInicial: @collected_alteration_date.strftime, dataAlteracaoFinal: final_alteration_date }
      orders = Services::Bling::Order.call(order_command: 'find_orders', tenant: account_id,
                                           situation: STATUS, options: options)
      orders = orders['data']

      create_orders(orders)
    end
  end

  def create_orders(orders)
    return if orders.blank?

    order_ids = orders.map { |order| order['id'] }

    query_bling_order_ids = BlingOrderItem.where(bling_order_id: order_ids)
                                          .map { |order| order.bling_order_id.to_i }

    orders_attributes = []
    BlingOrderItem.where(bling_order_id: [query_bling_order_ids])
                  .update_all(situation_id: @status, account_id:)

    orders.each do |order|
      next if query_bling_order_ids.include?(order['id'])

      orders_attributes << {
        bling_order_id: order['id'],
        situation_id: order['situacao']['id'],
        store_id: order['loja']['id'],
        date: order['data'],
        collected_alteration_date: @collected_alteration_date,
        alteration_date: @collected_alteration_date,
        marketplace_code_id: order['numeroLoja'],
        bling_id: order['numero'],
        account_id:,
        value: order['total']
      }
    end

    BlingOrderItem.create(orders_attributes)
  end
end
