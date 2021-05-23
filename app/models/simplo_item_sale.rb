# frozen_string_literal: true

class SimploItemSale < ApplicationRecord
  def self.integrate_item_sale
    @order_page = HTTParty.get('https://purchasestore.com.br/ws/wspedidos.json?data_inicio=2020-11-01',
                               headers: { content: 'application/json',
                                          Appkey: 'ZTgyYjMzZDJhMDVjMTVjZWM4OWNiMGU5NjI1NTNkYmU' })
    (1..@order_page['pagination']['page_count']).each do |i|
      @order_page = HTTParty.get("https://purchasestore.com.br/ws/wspedidos.json?page=#{i}",
                                 headers: { content: 'application/json',
                                            Appkey: 'ZTgyYjMzZDJhMDVjMTVjZWM4OWNiMGU5NjI1NTNkYmU' })
      @order_page['result'].each do |order_page|
        if order_page["Wspedido"]["pedidostatus_id"] != '24' && order_page["Wspedido"]["pedidostatus_id"] != '1' && order_page["Wspedido"]["pedidostatus_id"] != '4' #vendas diárias
          order_page['Item'].each do |item|
            begin
              SimploItemSale.create(nome_produto: item['nome_produto'], 
                                    produto_id: item['produto_id'], 
                                    sku: item['sku'], 
                                    quantidade: item['quantidade'].to_i,
                                    valor_unitario: item['valor_unitario'], 
                                    valor_total: item['valor_total'], peso: item['peso'], 
                                    desconto: item['desconto'], 
                                    data_pedido: DateTime.parse(order_page['Wspedido']['data_pedido']),
                                    order_id: (item['pedido_id']).to_i - 1).to_s
            rescue ArgumentError
              puts 'erro'
            end
          end
        end
      end
    end
  end
end
