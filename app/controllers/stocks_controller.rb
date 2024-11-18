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
        if params[:detailed]
          begin
            csv_data = generate_detailed_csv
            send_data csv_data, 
              filename: "detailed_stock_calculations_#{Date.today}.csv",
              type: 'text/csv; charset=utf-8',
              disposition: 'attachment'
          rescue => e
            Rails.logger.error "Error generating CSV: #{e.message}"
            flash[:error] = "Erro ao gerar o CSV. Por favor, tente novamente."
            redirect_to stocks_path
          end
        else
          begin
            csv_data = generate_regular_csv
            send_data csv_data,
              filename: "stock_calculations_#{Date.today}.csv",
              type: 'text/csv; charset=utf-8',
              disposition: 'attachment'
          rescue => e
            Rails.logger.error "Error generating CSV: #{e.message}"
            flash[:error] = "Erro ao gerar o CSV. Por favor, tente novamente."
            redirect_to stocks_path
          end
        end
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
    discounted_physical_balance = @stock.discounted_balance(balance)

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
          discounted_physical_balance: discounted_physical_balance,
          adjusted_balance: adjusted_balance,
          new_forecast: new_forecast,
          number_of_pieces_per_fabric_roll: @stock.product.number_of_pieces_per_fabric_roll
        } 
      }
    end
  end

  protected
  
  def collection
    @default_status_filter = params['status']
    @default_situation_balance_filter = params['balance_situation']
    @default_sku_filter = params['sku']
    @default_period_filter = params['period'] || '30'
    @default_tipo_estoque = params['tipo_estoque'] || 'null'

    stocks = Stock.where(account_id: current_tenant)
                  .includes(:product, :balances)
                  .only_positive_price(true)
                  .filter_by_status(params['status'])
                  .filter_by_total_balance_situation(params['balance_situation'])
                  .filter_by_sku(params['sku'])
                  .joins(:product)

    # Calculate total balance for null tipo_estoque products
    default_warehouse_id = '9023657532'  # ID for Estoque São Paulo Base
    null_tipo_stocks = Stock.where(account_id: current_tenant)
                           .joins(:product)
                           .includes(:product)
                           .where(products: { tipo_estoque: nil })
                           .includes(:balances)
                           .to_a

    Rails.logger.info "Starting balance calculations..."
    
    @total_null_balance = null_tipo_stocks.sum do |stock|
      balance = stock.balances.find { |b| b.deposit_id.to_s == default_warehouse_id }
      next 0 unless balance
      
      # Get the base physical balance
      physical_balance = balance.physical_balance
      
      # Calculate the actual balance based on conditions
      actual_balance = if stock.discounted_warehouse_sku_id == "#{default_warehouse_id}_#{stock.product.sku}"
                        # If discounted, subtract 1000 first
                        discounted = physical_balance - 1000
                        # If the discounted value is negative, don't count this stock
                        discounted <= 0 ? 0 : discounted
                      else
                        # If not discounted, apply the regular rules
                        if physical_balance >= 1000
                          physical_balance - 1000
                        elsif physical_balance <= 0
                          0
                        else
                          physical_balance
                        end
                      end
      
      Rails.logger.info "SKU: #{stock.product.sku} | Physical Balance: #{physical_balance} | Actual Balance: #{actual_balance} | Discounted?: #{stock.discounted_warehouse_sku_id.present?}"
      
      actual_balance
    end

    Rails.logger.info "Total balance calculated: #{@total_null_balance}"

    stocks = case @default_tipo_estoque
            when 'null'
              stocks.where(products: { tipo_estoque: nil })
            when 'V'
              stocks.where(products: { tipo_estoque: 'V' })
            when 'P'
              stocks.where(products: { tipo_estoque: 'P' })
            else
              stocks
            end

    @warehouses = Warehouse.where(account_id: current_tenant).pluck(:bling_id, :description).to_h

    days = @default_period_filter.to_i
    start_date = days.days.ago.to_date
    end_date = Date.today

    items_sold = Item.joins(:bling_order_item)
                     .where(account_id: current_tenant,
                            bling_order_items: { date: start_date..end_date })
                     .group(:sku)
                     .sum(:quantity)

    total_in_production = Stock.total_in_production_for_all

    stocks_with_forecasts = stocks.map do |stock|
      total_sold = items_sold[stock.product.sku] || 0
      
      default_balance = stock.balances.find { |b| b.deposit_id.to_s == default_warehouse_id }
      physical_balance = default_balance ? default_balance.physical_balance : 0
      virtual_balance = default_balance ? default_balance.virtual_balance : 0
      in_production = stock.total_in_production

      # Calculate discounted balances if default_balance exists
      discounted_physical_balance = default_balance ? stock.discounted_balance(default_balance) : 0
      discounted_virtual_balance = default_balance ? stock.discounted_virtual_balance(default_balance) : 0

      # Calculate adjusted balances if default_balance exists
      adjusted_physical_balance = default_balance ? stock.adjusted_balance(default_balance) : 0
      adjusted_virtual_balance = default_balance ? stock.adjusted_virtual_balance(default_balance) : 0

      # Calculate forecast only if we have adjusted_physical_balance
      total_forecast = if adjusted_physical_balance && !stock.product.composed?
                        [total_sold - adjusted_physical_balance, 0].max
                      else
                        0
                      end

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

    # Sort by total_sold, but handle nil values
    sorted_stocks = stocks_with_forecasts.sort_by { |_, data| -(data[:total_sold] || 0) }

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

  def generate_detailed_csv
    require 'csv'

    default_warehouse_id = '9023657532'
    stocks = Stock.where(account_id: current_tenant)
                  .includes(:product, :balances)
                  .joins(:product)
                  .where(products: { tipo_estoque: nil })

    CSV.generate(headers: true, col_sep: ';', encoding: 'UTF-8') do |csv|
      csv << [
        'SKU', 'Saldo Físico'
      ]

      stocks.each do |stock|
        begin
          balance = stock.balances.find { |b| b.deposit_id.to_s == default_warehouse_id }
          next unless balance

          physical_balance = if stock.discounted_warehouse_sku_id == "#{default_warehouse_id}_#{stock.product.sku}"
                             stock.discounted_balance(balance)
                           else
                             balance.physical_balance
                           end

          csv << [
            stock.product.sku,
            physical_balance || 0
          ]
        rescue => e
          Rails.logger.error "Error processing stock #{stock.id}: #{e.message}"
          next
        end
      end
    end
  end

  def generate_regular_csv
    CSV.generate(headers: true, col_sep: ';', encoding: 'UTF-8') do |csv|
      csv << ['id', 'SKU', 'Saldo Total', 'Saldo Virtual Total', 'Quantidade Vendida dos Últimos 30 dias',
              'Previsão para os Próximos 30 dias', 'Produto']
      
      stocks = Stock.where(account_id: current_tenant)
                   .includes(:product, :balances)
                   .joins(:product)
                   .where(products: { tipo_estoque: nil })
                   .sort_by(&:calculate_basic_forecast)
                   .reverse!

      stocks.each do |stock|
        next if stock.total_balance.zero? && stock.count_sold.zero?

        row = [stock.id, stock.sku, stock.total_balance, stock.total_virtual_balance, stock.count_sold,
               stock.calculate_basic_forecast,
               stock.product.name]
        csv << row
      end
    end
  end
end