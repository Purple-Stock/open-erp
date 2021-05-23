class SimploOrderPayment < ApplicationRecord

  def self.integrate_orders
    @order_page = HTTParty.get('https://purchasestore.com.br/ws/wspedidos.json?data_inicio=2020-12-01',
                               headers: { content: 'application/json',
                                          Appkey: 'ZTgyYjMzZDJhMDVjMTVjZWM4OWNiMGU5NjI1NTNkYmU' })
    (1..@order_page['pagination']['page_count']).each do |i|
      @order_page = HTTParty.get("https://purchasestore.com.br/ws/wspedidos.json?page=#{i}",
                                 headers: { content: 'application/json',
                                            Appkey: 'ZTgyYjMzZDJhMDVjMTVjZWM4OWNiMGU5NjI1NTNkYmU' })
      puts "Página #{i}"
      @order_page['result'].each do |order_page|
        order = HTTParty.get("https://purchasestore.com.br/ws/wspedidos/numero/#{order_page["Wspedido"]['numero']}.json",
                            headers: { content: 'application/json',
                                      Appkey: 'ZTgyYjMzZDJhMDVjMTVjZWM4OWNiMGU5NjI1NTNkYmU' })
        puts "Pedido #{order_page["Wspedido"]['numero']}"                              
        if order['result']["Wspedido"]["pedidostatus_id"] != '24' && order['result']["Wspedido"]["pedidostatus_id"] != '1' && order['result']["Wspedido"]["pedidostatus_id"] != '4' #vendas diárias
          begin
            SimploOrderPayment.create(client_name: order['result']["Wspedido"]['cliente_razaosocial'], 
                                      integrador: order['result']['Pagamento']['integrador'], 
                                      pagamento_forma: order['result']['Pagamento']['pagamento_forma'], 
                                      codigo_transacao: order['result']['Pagamento']['codigo_transacao'],
                                      parcelas: order['result']['Pagamento']['parcelas'], 
                                      order_status: order['result']["Wspedido"]["pedidostatus_id"], 
                                      total: order['result']["Wspedido"]['total_pedido'], 
                                      data_pedido: DateTime.parse(order['result']['Wspedido']['data_pedido']),
                                      order_id: order['result']["Wspedido"]['numero'])
          rescue ArgumentError
            puts 'erro'
          end
        end
      end
    end
  end
end
