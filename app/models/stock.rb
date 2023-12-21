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
  belongs_to :product, foreign_key: :bling_product_id

  validates :bling_product_id, :total_balance, :total_virtual_balance,
            numericality: { numericality: true, only_integer: true }

  delegate :active, :bling_id, to: :product

  def self.synchronize_bling(tenant, bling_product_ids)
    options = { idsProdutos: bling_product_ids }
    results = Services::Bling::Stock.call(stock_command: 'find_stocks', tenant:, options:)
    results['data'].each do |bling|
      attributes = {
        total_balance: bling['saldoFisicoTotal'],
        total_virtual_balance: bling['saldoVirtualTotal'],
        bling_product_id: bling['produto']['id'],
        account_id: tenant
      }
      product = Product.find_by(bling_id: bling['produto']['id'])
      stock = Stock.new(attributes)
      product.stock = stock
      product.save
    end
  end
end
