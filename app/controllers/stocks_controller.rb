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
    new_physical_balance = params[:new_physical_balance]
    new_forecast = params[:new_forecast]

    if is_applying
      @stock.apply_discount(warehouse_id)
    else
      @stock.remove_discount
    end

    balance = @stock.balances.find_by(deposit_id: warehouse_id)
    balance.update(physical_balance: new_physical_balance)

    respond_to do |format|
      format.json { 
        render json: { 
          success: true, 
          physical_balance: new_physical_balance,
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
      in_production = stock.total_in_production

      # Check if discount is applied
      if stock.discounted_warehouse_sku_id == "#{default_warehouse_id}_#{stock.product.sku}"
        physical_balance -= 1000
      end

      # Calculate forecast
      total_forecast = [physical_balance + in_production - total_sold, 0].max

      [stock, { 
        total_sold: total_sold, 
        total_forecast: total_forecast,
        physical_balance: physical_balance,
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