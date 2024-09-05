module Forecasts
  # This class is simple as it is.
  # Born to answer this question:
  # "Given I sold 2 items according to their sku in a range of 30 days before today,
  # How many products I need to add to my actual stock? Assuming I expect the same demand
  # for the next 30 days"
  class BasicStock
    attr_reader :stock, :sku, :start_date, :end_date, :account_id, :options

    NO_NEED_TO_INCREASE_STOCK = 0

    def initialize(stock, options = {})
      @stock = stock
      @sku = stock.sku
      @end_date = options[:end_date] || Date.today
      @start_date = options[:start_date] || @end_date - 1.month
      @account_id = stock.account_id
      @options = options
    end

    def self.bulk_calculate(stocks, items_sold)
      stocks.map do |stock|
        sold_quantity = items_sold[stock.sku] || 0
        forecast = [sold_quantity - stock.total_balance, 0].max
        [stock, forecast]
      end
    end
    

    def calculate
      stock_to_repair_quantity = count_sold - stock.total_balance
      [stock_to_repair_quantity, NO_NEED_TO_INCREASE_STOCK].max
    end

    def count_sold
      @count_sold ||= Item.joins(:bling_order_item)
                          .where(bling_order_item: { date: start_date..end_date }, 
                                 account_id: account_id, 
                                 sku: sku)
                          .sum(:quantity)
    end
  end
end