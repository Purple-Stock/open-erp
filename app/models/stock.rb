# == Schema Information
#
# Table name: stocks
#
#  id                          :bigint           not null, primary key
#  total_balance               :integer
#  total_virtual_balance       :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  account_id                  :integer
#  bling_product_id            :bigint
#  discounted_warehouse_sku_id :string
#  product_id                  :integer
#
class Stock < ApplicationRecord
  require 'forecasts/basic_stock'

  attr_accessor :basic_forecast

  belongs_to :product, class_name: 'Product', inverse_of: :stock

  validates :bling_product_id, :total_balance, :total_virtual_balance,
            numericality: { numericality: true, only_integer: true }

  delegate :active, :bling_id, :name, :sku, to: :product

  def self.filter_by_total_balance_situation(balance_situation = nil)
    return all if balance_situation.blank?

    balance_situation_parser = { 1 => '>', -1 => '<', 0 => '=' }
    balance_situation = balance_situation_parser[balance_situation.to_i]
    where("total_balance #{balance_situation} ?", 0)
  end

  def self.filter_by_status(status_number = nil)
    return all if status_number.blank?

    joins(:product).where(products: { active: status_number })
  end

  def self.only_positive_price(query = false)
    return all unless query

    joins(:product).where('products.price > ?', 0)
  end

  def self.to_csv
    CSV.generate(headers: true, col_sep: ';') do |csv|
      csv << ['id', 'SKU', 'Saldo Total', 'Saldo Virtual Total', 'Quantidade Vendida dos Últimos 30 dias',
              'Previsão para os Próximos 30 dias', 'Produto']
      all.sort_by(&:calculate_basic_forecast).reverse!.each do |stock|
        next if stock.total_balance.zero? && stock.count_sold.zero?

        row = [stock.id, stock.sku, stock.total_balance, stock.total_virtual_balance, stock.count_sold,
               stock.calculate_basic_forecast,
               stock.product.name]
        csv << row
      end
    end
  end

  def basic_forecast
    @basic_forecast ||= Forecasts::BasicStock.new(self)
  end

  def calculate_basic_forecast
    @calculate_basic_forecast ||= basic_forecast.calculate
  end

  def count_sold
    basic_forecast.count_sold
  end

  has_many :balances, dependent: :destroy

  def self.synchronize_bling(tenant, bling_product_ids)
    options = { idsProdutos: Array(bling_product_ids) }
    begin
      Rails.logger.info "Starting Bling stock synchronization for tenant: #{tenant}, product IDs: #{bling_product_ids}"
      results = Services::Bling::Stock.call(stock_command: 'find_stocks', tenant:, options:)
    rescue StandardError => e
      Rails.logger.error "Error synchronizing Bling stocks: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      return { error: e.message }
    end

    Rails.logger.info "Bling API response: #{results.inspect}"

    stocks = Stock.where(account_id: tenant)
    results['data'].each do |bling|
      attributes = {
        total_balance: bling['saldoFisicoTotal'],
        total_virtual_balance: bling['saldoVirtualTotal'],
        bling_product_id: bling['produto']['id'],
        account_id: tenant
      }

      stock = stocks.find_or_initialize_by(bling_product_id: bling['produto']['id'])
      if stock.new_record?
        product = Product.find_by(bling_id: bling['produto']['id'])
        stock.product = product
      end
      stock.update(attributes)

      bling['depositos'].each do |deposito|
        stock.balances.find_or_initialize_by(deposit_id: deposito['id']).update(
          physical_balance: deposito['saldoFisico'],
          virtual_balance: deposito['saldoVirtual']
        )
      end
    end
    Rails.logger.info "Bling stock synchronization completed successfully"
    { success: true }
  end

  def self.filter_by_sku(sku = nil)
    return all if sku.blank?

    joins(:product).where('products.sku ILIKE ?', "%#{sku}%")
  end

  def apply_discount(warehouse_id)
    self.discounted_warehouse_sku_id = "#{warehouse_id}_#{self.product.sku}"
    save
  end

  def remove_discount
    self.discounted_warehouse_sku_id = nil
    save
  end

  def balance(balance)
    result = discounted_balance(balance)
    Rails.logger.debug "Stock ##{id} balance: #{result} (base: #{balance.physical_balance}, in_production: #{total_in_production})"
    result
  end

  def virtual_balance(balance)
    discounted_virtual_balance(balance)
  end

  def discounted_balance(balance)
    base_balance = if discounted_warehouse_sku_id == "#{balance.deposit_id}_#{self.product.sku}"
      balance.physical_balance - 1000
    else
      balance.physical_balance
    end
    base_balance + total_in_production
  end

  def discounted_virtual_balance(balance)
    base_balance = if discounted_warehouse_sku_id == "#{balance.deposit_id}_#{self.product.sku}"
      balance.virtual_balance - 1000
    else
      balance.virtual_balance
    end
    base_balance + total_in_production
  end

  def total_in_production
    result = @total_in_production ||= self.class.total_in_production_for_all[self.product_id] || 0
    Rails.logger.debug "Stock ##{id} total_in_production: #{result}"
    result
  end

  def adjusted_total_balance
    total_balance + total_in_production
  end

  def adjusted_total_virtual_balance
    total_virtual_balance + total_in_production
  end

  def self.total_in_production_for_all
    ProductionProduct.joins(:production)
                     .where(productions: { confirmed: [false, nil] })
                     .group(:product_id)
                     .sum('quantity - COALESCE(pieces_delivered, 0) - COALESCE(dirty, 0) - COALESCE(error, 0) - COALESCE(discard, 0)')
  end
end
