# == Schema Information
#
# Table name: simplo_orders
#
#  id           :bigint           not null, primary key
#  client_name  :string
#  order_date   :string
#  order_status :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  order_id     :string
#
class SimploOrder < ApplicationRecord
  has_many :simplo_items

  def self.integrate_order_items
    @order_page = Requests::Order.new.call

    (1..@order_page['pagination']['page_count']).each do |i|
      @order_page = Requests::Order.new(page: i).call

      @order_page['result'].each do |order_page|
        order = SimploOrder.find_by(order_id: order_page['Wspedido']['numero'])
        if order.nil?
          simplo_order = SimploOrder.create(client_name: order_page['Wspedido']['cliente_razaosocial'],
                                            order_id: order_page['Wspedido']['numero'],
                                            order_status: order_page['Wspedido']['pedidostatus_id'],
                                            order_date: Time.parse(order_page['Wspedido']['data_pedido']))
          order_page['Item'].each do |item|
            product = Product.where(sku: item['sku']).or(Product.where(extra_sku: item['sku'])).first
            if product.present?
              SimploItem.create(sku: item['sku'], quantity: item['quantidade'].to_i, simplo_order_id: simplo_order.id,
                                product_id: product.id)
            else
              SimploItem.create(sku: item['sku'], quantity: item['quantidade'].to_i, simplo_order_id: simplo_order.id)
            end
          end
        elsif order.order_status != order_page['Wspedido']['pedidostatus_id']
          order.update(order_status: order_page['Wspedido']['pedidostatus_id'])
        end
      rescue ArgumentError
        puts 'erro'
      end
    end
  end

  def self.update_order_status(order_number, order_status)
    id = (order_number.to_i + 1).to_s
    data = { 'Wspedido': { 'Status': { 'id': order_status } } }
    begin
      Updates::Order.new(id:, data:).call
    rescue ArgumentError
      puts 'erro'
    end
  end

  def self.update_postal_code(order_number, post_code)
    id = (order_number.to_i + 1).to_s
    data = { 'Wspedido': { 'Entrega': { 'rastreamento': post_code } } }
    begin
      Updates::Order.new(id:, data:).call
    rescue ArgumentError
      puts 'erro'
    end
  end

  def self.update_order_status_postal_code(order_number, order_status, post_code)
    id = (order_number.to_i + 1).to_s
    os_data = { 'Wspedido': { 'Status': { 'id': order_status } } }
    pc_data = { 'Wspedido': { 'Entrega': { 'rastreamento': post_code } } }
    begin
      Updates::Order.new(id:, data: os_data).call
      Updates::Order.new(id:, data: pc_data).call
    rescue ArgumentError
      puts 'erro'
    end
  end

  def self.calendar
    Business::Calendar.new(
      working_days: %w[mon tue wed thu fri],
      holidays: ['20/11/2020', '25/12/2020']
    )
  end
end
