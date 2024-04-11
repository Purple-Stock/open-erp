# frozen_string_literal: true

# DailyErrorOrderJob perform against created orders set previously
# with another status.
# For this reason, we should call this job as an updater job.
# The crucial difference here is the absence of the alteration date in the bling API response.
# It is possible to filter by alteration date, however the alteration date (dataAlteraçãoInicial) is not
# present in the response. Our solution is querying by alteration date assuming it is the same in bling API
# setting this assumed value directly on our database.
# Motives to run this job:
# There are orders status over counted. There are possibilities they became Error on bling API
class DailyErrorOrderJob < BlingOrderItemCreatorBaseJob
  STATUS = BlingOrderItem::Status::ERROR.freeze

  attr_accessor :account_id

  def perform(account_id, initial_alteration_date = nil)
    @status = STATUS
    @account_id = account_id
    @initial_date = initial_alteration_date || Date.today
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
