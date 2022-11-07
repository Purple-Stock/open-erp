# frozen_string_literal: true

# == Schema Information
#
# Table name: simplo_products
#
#  id         :bigint           not null, primary key
#  name       :string
#  sku        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SimploProduct < ApplicationRecord
  def simplo_products
    @products = Requests::Product.new(page: '1').call
    @products['result'].each do |product|
      name = product['Wsproduto']['nome']
      product['WsprodutoEstoque'].each do |sku_product|
        SimploProduct.create(name:, sku: sku_product['sku'])
      end
    end
  end
end
