class HomeController < ApplicationController
  def index
    begin 
      response = Services::Bling::Order.call(order_command: 'find_orders', tenant: current_user.account.id)

      @orders = response['data']

      order_ids = @orders.select { |order| order['loja']['id'] == 204_061_683 }.map { |order| order['id'] }

      @mercado_envios_flex_counts = count_mercado_envios_flex(order_ids)

      @store_name = get_loja_name

      @loja_ids = [204_219_105, 203_737_982, 203_467_890, 204_061_683]

      @last_update = format_last_update(Time.current)
    rescue StandardError => e
      Rails.logger.error(e.message)
      redirect_to home_last_updates_path
    end
  end

  def last_updates
    @custumers = Customer.order(id: :desc).limit(10)
    @products = Product.order(id: :desc).limit(10)
  end

  private

  def count_mercado_envios_flex(order_ids)
    counter = 0
    order_ids.each do |order_id|
      response = Services::Bling::FindOrder.call(id: order_id, order_command: 'find_order', tenant: current_user.account.id)
      order = response['data']

      shipping = order['transporte']
      shipping_service = shipping['volumes'][0]['servico']
      counter += 1 if shipping_service == 'Mercado Envios Flex'
    end
    counter
  end

  def format_last_update(time)
    time.strftime('%d-%m-%Y %H:%M:%S')
  end

  def get_loja_name
    {
      204_219_105 => 'Shein',
      203_737_982 => 'Shopee',
      203_467_890 => 'Simplo 7',
      204_061_683 => 'Mercado Livre'
    }
  end
end
