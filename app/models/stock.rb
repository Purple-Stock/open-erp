# == Schema Information
#
# Table name: stocks
#
#  id                    :bigint           not null, primary key
#  total_balance         :integer
#  total_virtual_balance :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  bling_product_id      :bigint
#  product_id            :integer
#
class Stock < ApplicationRecord
  validates :bling_product_id, :total_balance, :total_virtual_balance,
            numericality: { numericality: true, only_integer: true }

  def self.synchronize_bling(tenant, bling_product_ids)
    attributes = []
    options = { idsProdutos: bling_product_ids }
    results = Services::Bling::Stock.call(stock_command: 'find_stocks', tenant:, options:)
    results['data'].each do |bling|
      attributes << {
        total_balance: bling['saldoFisicoTotal'],
        total_virtual_balance: bling['saldoVirtualTotal'],
        bling_product_id: bling['produto']['id']
      }
    end

    Stock.create(attributes)
  end
end
