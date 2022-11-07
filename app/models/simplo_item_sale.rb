# frozen_string_literal: true

# == Schema Information
#
# Table name: simplo_item_sales
#
#  id             :bigint           not null, primary key
#  data_pedido    :datetime
#  desconto       :float
#  nome_produto   :string
#  peso           :float
#  quantidade     :integer
#  sku            :string
#  valor_total    :float
#  valor_unitario :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  order_id       :string
#  produto_id     :string
#
class SimploItemSale < ApplicationRecord
  def self.integrate_item_sale
    custom_uri = 'https://purchasestore.com.br/ws/wspedidos.json?data_inicio=2020-11-01'
    @order_page = Requests::Order.new(custom_uri:).call

    (1..@order_page['pagination']['page_count']).each do |i|
      @order_page = Requests::Order.new(page: i).call

      @order_page['result'].each do |order_page|
        unless order_page['Wspedido']['pedidostatus_id'] != '24' && order_page['Wspedido']['pedidostatus_id'] != '1' && order_page['Wspedido']['pedidostatus_id'] != '4'
          next
        end

        order_page['Item'].each do |item|
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
          Rails.logger.debug 'erro'
        end
      end
    end
  end
end
