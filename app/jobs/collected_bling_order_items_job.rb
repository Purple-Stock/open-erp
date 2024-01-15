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

  attr_accessor :account_id

  def perform(account_id, initial_alteration_date = nil)
    @status = STATUS
    @account_id = account_id
    @initial_date = initial_alteration_date || Date.today - 3.months
    @final_date = Date.today
    date_range = (@initial_date..@final_date)
    date_range.each do |alteration_date|
      @alteration_date = alteration_date
      final_alteration_date = (alteration_date + 1.day).strftime
      options = { dataAlteracaoInicial: @alteration_date.strftime, dataAlteracaoFinal: final_alteration_date }
      orders = Services::Bling::Order.call(order_command: 'find_orders', tenant: account_id,
                                           situation: STATUS, options: options)
      orders = orders['data']

      create_orders(orders)
    end
  end
end
