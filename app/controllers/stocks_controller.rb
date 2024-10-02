# frozen_string_literal: true

class StocksController < ApplicationController
  include Pagy::Backend
  before_action :set_stock, only: [:show, :apply_discount]

  def index
    respond_to do |format|
      format.html do
        @stocks_with_data = collection
      end
      format.csv do
        GenerateStocksCsvJob.perform_later(current_tenant, current_user.email)
        flash[:notice] = "CSV is being generated and will be emailed to you shortly."
        redirect_to stocks_path
      end
    end
  end

  def show
    @warehouses = Warehouse.where(account_id: current_tenant).pluck(:bling_id, :description).to_h
    # The @stock variable is now set by the before_action
  end

  def apply_discount
    warehouse_id = params[:warehouse_id]
    sku = params[:sku]
    is_applying = params[:is_applying]

    if is_applying
      @stock.apply_discount(warehouse_id)
    else
      @stock.remove_discount
    end

    balance = @stock.balances.find_by(deposit_id: warehouse_id)
    adjusted_balance = @stock.adjusted_balance(balance)

    start_date = 1.month.ago.to_date
    end_date = Date.today
    total_sold = Item.joins(:bling_order_item)
                     .where(account_id: current_tenant, sku: sku, bling_order_items: { date: start_date..end_date })
                     .sum(:quantity)

    new_forecast = [total_sold - adjusted_balance, 0].max

    respond_to do |format|
      format.json { 
        render json: { 
          success: true, 
          physical_balance: balance.physical_balance,
          adjusted_balance: adjusted_balance,
          new_forecast: new_forecast
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

    default_warehouse_id = '9023657532'  # ID for Estoque São Paulo Base

    total_in_production = Stock.total_in_production_for_all

    stocks_with_forecasts = stocks.map do |stock|
      total_sold = items_sold[stock.product.sku] || 0
      
      default_balance = stock.balances.find { |b| b.deposit_id.to_s == default_warehouse_id }
      physical_balance = default_balance ? default_balance.physical_balance : 0
      virtual_balance = default_balance ? default_balance.virtual_balance : 0
      in_production = stock.total_in_production

      # Calculate discounted balances
      discounted_physical_balance = stock.discounted_balance(default_balance) if default_balance
      discounted_virtual_balance = stock.discounted_virtual_balance(default_balance) if default_balance

      # Calculate adjusted balances
      adjusted_physical_balance = stock.adjusted_balance(default_balance) if default_balance
      adjusted_virtual_balance = stock.adjusted_virtual_balance(default_balance) if default_balance

      # Calculate forecast: total_sold - adjusted_physical_balance
      total_forecast = [total_sold - adjusted_physical_balance, 0].max if adjusted_physical_balance

      [stock, { 
        total_sold: total_sold, 
        total_forecast: total_forecast,
        physical_balance: physical_balance,
        virtual_balance: virtual_balance,
        discounted_physical_balance: discounted_physical_balance,
        discounted_virtual_balance: discounted_virtual_balance,
        adjusted_physical_balance: adjusted_physical_balance,
        adjusted_virtual_balance: adjusted_virtual_balance,
        total_in_production: in_production,
        sao_paulo_base_balance: default_balance ? default_balance.physical_balance : 0
      }]
    end

    sorted_stocks = stocks_with_forecasts.sort_by { |_, data| -data[:total_sold] }

    @pagy, @stocks_with_data = pagy_array(sorted_stocks, items: 20)

    Rails.logger.debug "Total in production for all: #{total_in_production.inspect}"

    @stocks_with_data
  end

  private

  def set_stock
    @stock = Stock.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Stock not found"
    redirect_to stocks_path
  end
end