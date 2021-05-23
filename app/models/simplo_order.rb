class SimploOrder < ApplicationRecord
  has_many :simplo_items

  def self.integrate_order_items
    @order_page = HTTParty.get('https://purchasestore.com.br/ws/wspedidos.json',
                               headers: { content: 'application/json',
                                          Appkey: 'ZTgyYjMzZDJhMDVjMTVjZWM4OWNiMGU5NjI1NTNkYmU' })
    (1..@order_page['pagination']['page_count']).each do |i|
      @order_page = HTTParty.get("https://purchasestore.com.br/ws/wspedidos.json?page=#{i}",
                                 headers: { content: 'application/json',
                                            Appkey: 'ZTgyYjMzZDJhMDVjMTVjZWM4OWNiMGU5NjI1NTNkYmU' })
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
      HTTParty.put("https://purchasestore.com.br/ws/wspedidos/#{id}.json",
                   body: data,
                   headers: { content: 'application/json',
                              Appkey: 'ZTgyYjMzZDJhMDVjMTVjZWM4OWNiMGU5NjI1NTNkYmU' })
    rescue ArgumentError
      puts 'erro'
    end
  end

  def self.update_postal_code(order_number, post_code)
    id = (order_number.to_i + 1).to_s
    data = { 'Wspedido': { 'Entrega': { 'rastreamento': post_code } } }
    begin
      HTTParty.put("https://purchasestore.com.br/ws/wspedidos/#{id}.json",
                   body: data,
                   headers: { content: 'application/json',
                              Appkey: 'ZTgyYjMzZDJhMDVjMTVjZWM4OWNiMGU5NjI1NTNkYmU' })
    rescue ArgumentError
      puts 'erro'
    end
  end

  def self.update_order_status_postal_code(order_number, order_status, post_code)
    id = (order_number.to_i + 1).to_s
    os_data = { 'Wspedido': { 'Status': { 'id': order_status } } }
    pc_data = { 'Wspedido': { 'Entrega': { 'rastreamento': post_code } } }
    begin
      HTTParty.put("https://purchasestore.com.br/ws/wspedidos/#{id}.json",
                   body: os_data,
                   headers: { content: 'application/json',
                              Appkey: 'ZTgyYjMzZDJhMDVjMTVjZWM4OWNiMGU5NjI1NTNkYmU' })

      HTTParty.put("https://purchasestore.com.br/ws/wspedidos/#{id}.json",
                   body: pc_data,
                   headers: { content: 'application/json',
                              Appkey: 'ZTgyYjMzZDJhMDVjMTVjZWM4OWNiMGU5NjI1NTNkYmU' })
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
