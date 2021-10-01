class SimploProduct < ApplicationRecord
  def simplo_products
    @products = Requests::Product.new(page: '1').call
    @products['result'].each do |product|
      name = product['Wsproduto']['nome']
      product['WsprodutoEstoque'].each do |sku_product|
        SimploProduct.create(name: name, sku: sku_product['sku'])
      end
    end
  end
end
