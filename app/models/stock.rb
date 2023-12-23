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
  belongs_to :product, class_name: 'Product', inverse_of: :stock

  validates :bling_product_id, :total_balance, :total_virtual_balance,
            numericality: { numericality: true, only_integer: true }

  delegate :active, :bling_id, :name, to: :product

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
