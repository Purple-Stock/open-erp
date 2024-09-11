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
  
    stocks = Stock.where(account_id: current_tenant)
                  .includes(:product, :balances)
                  .only_positive_price(true)
                  .filter_by_status(params['status'])
                  .filter_by_total_balance_situation(params['balance_situation'])
  
    @warehouses = Warehouse.where(account_id: current_tenant).pluck(:bling_id, :description).to_h
  
    start_date = 1.month.ago.to_date
    end_date = Date.today
  
    items_sold = Item.joins(:bling_order_item)
                     .where(account_id: current_tenant,
                            bling_order_items: { date: start_date..end_date })
                     .group(:sku)
                     .sum(:quantity)
  
    stocks_with_forecasts = stocks.map do |stock|
      total_sold = items_sold[stock.product.sku] || 0
      total_physical_balance = stock.balances.sum(&:physical_balance)
      total_forecast = [total_sold - total_physical_balance, 0].max

      warehouse_forecasts = stock.balances.map do |balance|
        warehouse_forecast = if balance.physical_balance > 0
                               [total_sold - balance.physical_balance, 0].max
                             else
                               total_sold
                             end
        [balance.deposit_id, { sold: total_sold, forecast: warehouse_forecast }]
      end.to_h
      
      [stock, { warehouses: warehouse_forecasts, total_sold: total_sold, total_forecast: total_forecast }]
    end
  
    sorted_stocks = stocks_with_forecasts.sort_by { |_, data| -data[:total_sold] }
  
    @pagy, @stocks_with_data = pagy_array(sorted_stocks)
  end
end
