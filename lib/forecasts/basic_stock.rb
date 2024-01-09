# frozen_string_literal: true

module Forecasts
  # This class is simple as it is.
  # Born to answer this question:
  # "Given I sold 2 items according to their sku in a range of 30 days before today,
  # How many products I need to add to my actual stock? Assuming I expect the same demand
  # for the next 30 days"
  class BasicStock
    attr_accessor :stock, :sku, :date, :account_id, :items, :options

    def initialize(stock, options = {})
      @stock = stock
      @sku = stock.sku
      @date = Date.today - 1.month
      @account_id = stock.account_id
      @options = options
      @items = Item.joins(:bling_order_item).where(bling_order_item: { date: [date..] }, account_id:, sku:)
    end

    def calculate
      items.sum(:quantity)
    end
  end
end
