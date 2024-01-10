# frozen_string_literal: true

module Forecasts
  # This class is simple as it is.
  # Born to answer this question:
  # "Given I sold 2 items according to their sku in a range of 30 days before today,
  # How many products I need to add to my actual stock? Assuming I expect the same demand
  # for the next 30 days"
  class BasicStock
    attr_accessor :stock, :sku, :date, :account_id, :items, :options

    NO_NEED_TO_INCREASE_STOCK = 0

    def initialize(stock, options = {})
      @stock = stock
      @sku = stock.sku
      @date = Date.today - 1.month
      @account_id = stock.account_id
      @options = options
      @items = Item.joins(:bling_order_item).where(bling_order_item: { date: [date..] }, account_id:, sku:)
    end

    def calculate
      stock_to_repair_quantity = items.sum(:quantity) - stock.total_balance
      return NO_NEED_TO_INCREASE_STOCK if stock_to_repair_quantity.negative?

      stock_to_repair_quantity
    end
  end
end
