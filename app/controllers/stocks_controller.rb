# frozen_string_literal: true

class StocksController < ApplicationController
  require 'pagy/extras/array'
  include Pagy::ArrayExtra
  inherit_resources

  def index
    respond_to do |format|
      format.html { super }
      format.csv do
        @stocks_export = Stock.where(account_id: current_tenant)
        send_data @stocks_export.to_csv, file_name: 'stock_forecast.csv'
      end
    end
  end

  protected
  
  def collection
    @default_status_filter = params['status']
    @default_situation_balance_filter = params['balance_situation']
  
    # Fetch stocks with necessary associations
    stocks = Stock.where(account_id: current_tenant)
                  .includes(:product)
                  .only_positive_price(true)
                  .filter_by_status(params['status'])
                  .filter_by_total_balance_situation(params['balance_situation'])
  
    # Fetch all relevant items in a single query
    start_date = 1.month.ago.to_date
    end_date = Date.today
  
    items_sold = Item.joins(:bling_order_item)
                     .where(account_id: current_tenant,
                            bling_order_item: { date: start_date..end_date })
                     .group(:sku)
                     .sum(:quantity)
  
    # Calculate forecasts for each stock
    stocks_with_forecasts = stocks.map do |stock|
      sold_quantity = items_sold[stock.sku] || 0
      forecast = [sold_quantity - stock.total_balance, 0].max
      [stock, forecast]
    end
  
    # Sort stocks based on forecasts (in descending order)
    sorted_stocks = stocks_with_forecasts.sort_by { |_, forecast| -forecast }.map(&:first)
  
    # Paginate the sorted stocks
    @pagy, @stocks = pagy_array(sorted_stocks)
  end
end
