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

  def apply_discount
    @stock = Stock.find(params[:id])
    warehouse_id = params[:warehouse_id]
    sku = params[:sku]

    if @stock.discounted_warehouse_sku_id == "#{warehouse_id}_#{sku}"
      @stock.remove_discount
    else
      @stock.apply_discount(warehouse_id)
    end

    balance = @stock.balances.find_by(deposit_id: warehouse_id)
    
    # Fetch the total sold for this stock
    start_date = 1.month.ago.to_date
    end_date = Date.today
    total_sold = Item.joins(:bling_order_item)
                     .where(account_id: current_tenant, sku: sku, bling_order_items: { date: start_date..end_date })
                     .sum(:quantity)

    # Calculate the new forecast
    new_balance = @stock.balance(balance)
    new_forecast = if new_balance >= 0
                     [total_sold - new_balance, 0].max
                   else
                     total_sold + new_balance.abs
                   end

    respond_to do |format|
      format.json { 
        render json: { 
          success: true, 
          discounted_physical_balance: new_balance,
          discounted_virtual_balance: @stock.virtual_balance(balance),
          new_forecast: new_forecast,
          total_sold: total_sold
        } 
      }
    end
  end

  protected
  
  def collection
    @default_status_filter = params['status']
    @default_situation_balance_filter = params['balance_situation']
    @default_sku_filter = params['sku']

    stocks = Stock.where(account_id: current_tenant)
                  .includes(:product, :balances)
                  .only_positive_price(true)
                  .filter_by_status(params['status'])
                  .filter_by_total_balance_situation(params['balance_situation'])
                  .filter_by_sku(params['sku'])

    @warehouses = Warehouse.where(account_id: current_tenant).pluck(:bling_id, :description).to_h

    start_date = 1.month.ago.to_date
    end_date = Date.today

    items_sold = Item.joins(:bling_order_item)
                     .where(account_id: current_tenant,
                            bling_order_items: { date: start_date..end_date })
                     .group(:sku)
                     .sum(:quantity)

    default_warehouse_id = '9023657532'

    stocks_with_forecasts = stocks.map do |stock|
      total_sold = items_sold[stock.product.sku] || 0
      
      default_balance = stock.balances.find { |b| b.deposit_id.to_s == default_warehouse_id }
      total_physical_balance = default_balance ? stock.balance(default_balance) : 0

      # Separate calculation for total_forecast based on balance
      total_forecast = if total_physical_balance >= 0
                         [total_sold - total_physical_balance, 0].max
                       else
                         total_sold + total_physical_balance.abs
                       end

      warehouse_forecasts = stock.balances.map do |balance|
        warehouse_sold = balance.deposit_id.to_s == default_warehouse_id ? total_sold : 0
        balance_value = stock.balance(balance)
        # Separate calculation for warehouse_forecast based on balance
        warehouse_forecast = if balance_value >= 0
                               [warehouse_sold - balance_value, 0].max
                             else
                               warehouse_sold + balance_value.abs
                             end
        [balance.deposit_id, { sold: warehouse_sold, forecast: warehouse_forecast }]
      end.to_h
      
      [stock, { 
        warehouses: warehouse_forecasts, 
        total_sold: total_sold, 
        total_forecast: total_forecast,
        total_balance: total_physical_balance,
        total_virtual_balance: default_balance ? stock.virtual_balance(default_balance) : 0
      }]
    end
  
    sorted_stocks = stocks_with_forecasts.sort_by { |_, data| -data[:total_sold] }
  
    @pagy, @stocks_with_data = pagy_array(sorted_stocks)
  end

end
