class SimploProduct < ApplicationRecord

  def simplo_products
    @products = HTTParty.get("https://purchasestore.com.br/ws/wsprodutos.json?page=1",
               headers: { content: 'application/json',
                          Appkey: 'ZTgyYjMzZDJhMDVjMTVjZWM4OWNiMGU5NjI1NTNkYmU' 
                        })
    @products['result'].each do |product|
      name = product['Wsproduto']['nome']
      product['WsprodutoEstoque'].each do |sku_product|
        SimploProduct.create(name: name, sku: sku_product['sku'])
      end
    end
  end
end
