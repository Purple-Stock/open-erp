class SimploOrderPayment < ApplicationRecord
  def self.integrate_orders
    request_by_date = 'https://purchasestore.com.br/ws/wspedidos.json?data_inicio=2020-12-01'
    @order_page = Requests::Order.new(custom_uri: request_by_date).call

    (1..@order_page['pagination']['page_count']).each do |i|
      @order_page = Requests::Order.new(page: i).call
      puts "Página #{i}"

      @order_page['result'].each do |order_page|
        custom_uri = "https://purchasestore.com.br/ws/wspedidos/numero/#{order_page['Wspedido']['numero']}.json"
        order = Requests::Order.new(custom_uri: custom_uri).call

        puts "Pedido #{order_page['Wspedido']['numero']}"
        unless order['result']['Wspedido']['pedidostatus_id'] != '24' && order['result']['Wspedido']['pedidostatus_id'] != '1' && order['result']['Wspedido']['pedidostatus_id'] != '4'
          next
        end

        begin
          SimploOrderPayment.create(client_name: order['result']['Wspedido']['cliente_razaosocial'],
                                    integrador: order['result']['Pagamento']['integrador'],
                                    pagamento_forma: order['result']['Pagamento']['pagamento_forma'],
                                    codigo_transacao: order['result']['Pagamento']['codigo_transacao'],
                                    parcelas: order['result']['Pagamento']['parcelas'],
                                    order_status: order['result']['Wspedido']['pedidostatus_id'],
                                    total: order['result']['Wspedido']['total_pedido'],
                                    data_pedido: DateTime.parse(order['result']['Wspedido']['data_pedido']),
                                    order_id: order['result']['Wspedido']['numero'])
        rescue ArgumentError
          puts 'erro'
        end
      end
    end
  end
end
