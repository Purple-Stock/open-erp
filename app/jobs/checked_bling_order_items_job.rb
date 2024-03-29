# frozen_string_literal: true

# CheckedOrderItemsJob perform against created orders set previously
# with another status.
# For this reason, we should call this job as an updater job.
# The crucial difference here is the absence of the alteration date in the bling API response.
# It is possible to filter by alteration date, however the alteration date (dataAlteraçãoInicial) is not
# present in the response. Our solution is querying by alteration date assuming it is the same in bling API
# setting this assumed value directly on our database.
# This job was designed to be general and running once.
# Motives to run this job:
# 1) You cleaned your database;
# 2) There are orders status over counted. There are possibilities they became checked or verified on bling API
# but somehow the CurrentDoneBlingOrderJob does not update that.
class CheckedBlingOrderItemsJob < BlingOrderItemCreatorBaseJob
  STATUS = BlingOrderItem::Status::CHECKED.freeze

  attr_accessor :account_id

  def perform(account_id, initial_alteration_date = nil)
    @status = STATUS
    @account_id = account_id
    @initial_date = initial_alteration_date || Date.today - 3.months
    @final_date = Date.today
    threads = []
    date_range = (@initial_date..@final_date)
    date_range.each_slice(10) do |batch_alteration_dates|
      batch_alteration_dates.each do |alteration_date|
        @alteration_date = alteration_date
        threads << Thread.new do
          # As per https://guides.rubyonrails.org/threading_and_code_execution.html
          Rails.application.executor.wrap do
            final_alteration_date = (alteration_date + 1.day).strftime
            options = { dataAlteracaoInicial: alteration_date.strftime, dataAlteracaoFinal: final_alteration_date }
            orders = Services::Bling::Order.call(order_command: 'find_orders', tenant: account_id,
                                                 situation: STATUS, options: options)
            orders = orders['data']

            create_orders(orders, alteration_date)
          end
        end
      end
    end

    threads.each(&:join)
  end
end
