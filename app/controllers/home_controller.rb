class HomeController < ApplicationController
  before_action :set_monthly_revenue_estimation, only: :index

  def index
    @current_order_items = BlingOrderItem.where(situation_id: %w[94871 15 24 95745])
                                         .date_range_in_a_day(Time.zone.today)
    date_expires = token_expires_at

    refresh_token if date_expires < DateTime.now

    in_progress = Services::Bling::Order.call(order_command: 'find_orders', tenant: current_user.account.id,
                                              situation: 15)

    @orders = in_progress['data']

    checkeds = Services::Bling::Order.call(order_command: 'find_orders', tenant: current_user.account.id, situation: 24)

    @checked_orders = checkeds['data']

    pendings = Services::Bling::Order.call(order_command: 'find_orders', tenant: current_user.account.id,
                                           situation: 94_871)

    @pending_orders = pendings['data']

    update_orders_data

    printed = Services::Bling::Order.call(order_command: 'find_orders', tenant: current_user.account.id,
                                          situation: 95_745)

    @printed_orders = printed['data']

    order_ids = @orders&.select { |order| order['loja']['id'] == 204_061_683 }&.map { |order| order['id'] }

    @mercado_envios_flex_counts = count_mercado_envios_flex(order_ids)

    @store_name = get_loja_name

    @loja_ids = [204_219_105, 203_737_982, 203_467_890, 204_061_683]

    @expires_at = format_last_update(date_expires)

    @last_update = format_last_update(Time.current)
  rescue StandardError => e
    Rails.logger.error(e.message)
    redirect_to home_last_updates_path
  end

  def last_updates
    @custumers = Customer.order(id: :desc).limit(10)
    @products = Product.order(id: :desc).limit(10)
  end

  private

  def set_monthly_revenue_estimation
    @monthly_revenue_estimation = RevenueEstimation.current_month.take
  end

  def count_mercado_envios_flex(order_ids)
    return if order_ids.blank?

    counter = 0
    order_ids.each do |order_id|
      response = Services::Bling::FindOrder.call(id: order_id, order_command: 'find_order',
                                                 tenant: current_user.account.id)
      order = response['data']

      shipping = order['transporte']
      shipping_service = shipping['volumes'][0]['servico']
      counter += 1 if shipping_service == 'Mercado Envios Flex'
    rescue StandardError => e
      Rails.logger.error('Not Mercado Envios Flex')
      Rails.logger.error(e.message)
    end
    counter
  end

  def update_orders_data
    @in_progress = @orders
    BlingOrderItemCreatorJob.perform_later(@pending_orders, current_user)
    BlingOrderItemCreatorJob.perform_later(@checked_orders, current_user)
    BlingOrderItemCreatorJob.perform_later(@printed_orders, current_user)
    BlingOrderItemCreatorJob.perform_later(@in_progress, current_user)
  end

  def fetch_order_data(order_id)
    Services::Bling::FindOrder.call(id: order_id, order_command: 'find_order',
                                    tenant: current_user.account.id)
  end

  def format_last_update(time)
    time.strftime('%d-%m-%Y %H:%M:%S')
  end

  def token_expires_at
    BlingDatum.find_by(account_id: current_tenant.id).expires_at
  end

  def refresh_token
    refresh_token = BlingDatum.find_by(account_id: current_tenant.id).refresh_token
    client_id = ENV['CLIENT_ID']
    client_secret = ENV['CLIENT_SECRET']
    credentials = Base64.strict_encode64("#{client_id}:#{client_secret}")
    begin
      @response = HTTParty.post('https://bling.com.br/Api/v3/oauth/token',
                                body: {
                                  grant_type: 'refresh_token',
                                  refresh_token:
                                },
                                headers: {
                                  'Content-Type' => 'application/x-www-form-urlencoded',
                                  'Accept' => '1.0',
                                  'Authorization' => "Basic #{credentials}"
                                })

      verify_tokens
    rescue StandardError => e
      Rails.logger.error(e.message)
    end
  end

  def verify_tokens
    tokens = BlingDatum.find_by(account_id: current_tenant.id)
    tokens.update(access_token: @response['access_token'],
                  expires_in: @response['expires_in'],
                  expires_at: Time.zone.now + @response['expires_in'].seconds,
                  token_type: @response['token_type'],
                  scope: @response['scope'])
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
