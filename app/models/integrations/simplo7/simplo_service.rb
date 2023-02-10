# frozen_string_literal: true

module Integrations
  module Simplo7
    class SimploService
      def self.integrate_orders(id, store_sale)
        sale = Sale.where(order_code: id).first
        id = (id.to_i + 1).to_s
        if sale.nil?
          order = Requests::Order.new(id:).call

          customer = Customer.where(cpf: order['result']['Wspedido']['cliente_cpfcnpj'].delete('.-')).first
          customer = Customer.where(cpf: order['result']['Wspedido']['cliente_cpfcnpj']).first if customer.nil?
          if customer.nil?
            customer = Customer.create(cpf: order['result']['Wspedido']['cliente_cpfcnpj'],
                                       name: order['result']['Wspedido']['cliente_razaosocial'],
                                       cellphone: order['result']['Wspedido']['cliente_telefone'],
                                       email: order['result']['Wspedido']['cliente_email'])
          end
          if customer.present?
            sale = Sale.create(online: true,
                               customer_id: customer.id,
                               created_at: DateTime.parse(order['result']['Wspedido']['data_pedido']),
                               order_code: order['result']['Wspedido']['numero'],
                               value: order['result']['Wspedido']['total_produtos'],
                               discount: order['result']['Wspedido']['total_descontos'],
                               payment_type: order['result']['Pagamento']['integrador'] == 'Depósito Bancário' ? 'Depósito' : 'Crédito',
                               store_sale:)
            order['result']['Item'].each do |item|
              product = Product.where(sku: item['sku']).or(Product.where(extra_sku: item['sku'])).first
              if product.present?
                SaleProduct.create(quantity: item['quantidade'], value: item['valor_total'].to_f, product_id: product.id,
                                   sale_id: sale.id)
              else
                Rails.logger.debug "Product Not Found - Pedido #{id}"
              end
            end
          else
            Rails.logger.debug "Error Save Customer - Pedido #{id}"
          end
        else
          Rails.logger.debug "Pedido #{id} já cadastrado"
        end
      end

      def self.save_name_age
        (1..4).each do |i|
          custom_uri = "https://purchasestore.com.br/ws/wspedidos.json?data_inicio=2020-08-01&status=cancelado&page=#{i}"
          @order_page = Requests::Order.new(custom_uri:).call

          @order_page['result'].each do |order_page|
            SimploClient.create(name: order_page['Wspedido']['cliente_razaosocial'],
                                age: Time.zone.now.year - Time.zone.parse(order_page['Wspedido']['cliente_data_nascimento']).year,
                                order_date: Time.zone.parse(order_page['Wspedido']['data_pedido']))
          rescue ArgumentError
            Rails.logger.debug 'erro'
          end
        end
      end
    end
  end
end
