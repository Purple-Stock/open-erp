# == Schema Information
#
# Table name: stocks
#
#  id                    :bigint           not null, primary key
#  total_balance         :integer
#  total_virtual_balance :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  account_id            :integer
#  bling_product_id      :bigint
#  product_id            :integer
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

  def self.synchronize_bling(tenant, bling_product_ids)
    options = { idsProdutos: bling_product_ids }
    results = Services::Bling::Stock.call(stock_command: 'find_stocks', tenant:, options:)
    stocks = Stock.where(account_id: tenant)
    results['data'].each do |bling|
      if stocks.exists?(bling_product_id: bling['produto']['id'])
        attributes = {
          total_balance: bling['saldoFisicoTotal'],
          total_virtual_balance: bling['saldoVirtualTotal'],
        }

        stocks.find_by(bling_product_id: bling['produto']['id']).update(attributes)
      else
        attributes = {
          total_balance: bling['saldoFisicoTotal'],
          total_virtual_balance: bling['saldoVirtualTotal'],
          bling_product_id: bling['produto']['id'],
          account_id: tenant
        }
        product = Product.find_by(bling_id: bling['produto']['id'])
        stock = Stock.new(attributes)
        product.stock = stock
      end
    end
  end
end
