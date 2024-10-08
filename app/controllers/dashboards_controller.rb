class DashboardsController < ApplicationController
  before_action :token_expires_at, :date_range, :bling_order_items, :canceled_orders, :get_in_progress_order_items,
                :current_done_order_items, :set_monthly_revenue_estimation, :get_printed_order_items,
                :get_pending_order_items, :collected_orders, only: [:others_status, :metas_report]

  include SheinOrdersHelper

  def others_status
    authorize BlingOrderItem
    @shein_orders_count = SheinOrder.where("data ->> 'Status do pedido' = ?", 'Para ser coletado por SHEIN')
                                    .where(account_id: current_user.account.id)
                                    .distinct
                                    .count("data ->> 'Número do pedido'")

    @shein_pending_count = SheinOrder.where("data ->> 'Status do pedido' IN (?)", ['Pendente']).where(account_id: current_user.account.id)
                                     .distinct
                                     .count("data ->> 'Número do pedido'")

    @shein_orders = SheinOrder.where("data ->> 'Status do pedido' IN (?)",
                                     ['Para ser coletado por SHEIN', 'Pendente', 'Para ser enviado'])
                              .where(account_id: current_user.account.id)
    @expired_orders = @shein_orders.select { |order| order_status(order) == 'Atrasado' }
    @expired_orders_count = @expired_orders.count

    order_ids = @orders&.select { |order| order['loja']['id'] == 204_061_683 }&.map { |order| order['id'] }

    @mercado_envios_flex_counts = count_mercado_envios_flex(order_ids)

    @store_name = get_loja_name

    @loja_ids = [204_219_105, 203_737_982, 203_467_890, 204_061_683]

    @grouped_printed_order_items = BlingOrderItem.group_order_items(@printed_order_items)
    @grouped_pending_order_items = BlingOrderItem.group_order_items(@pending_order_items)
    @grouped_in_progress_order_items = BlingOrderItem.group_order_items(@in_progress_order_items)
  end

  def metas_report
    @monthly_revenue_estimation = current_user.account.revenue_estimations.current_month.first
    if @monthly_revenue_estimation.nil?
      @monthly_revenue_estimation = current_user.account.revenue_estimations.order(created_at: :desc).first
    end

    @bling_order_items = BlingOrderItem.where(account_id: current_user.account.id)
                                       .where('date >= ?', Date.today.beginning_of_month)
                                       .group_by(&:store_id)
  end

  private

  def token_expires_at
    @token_expires_at = BlingDatum.find_by(account_id: current_tenant.id).try(:expires_at)
  end

  def date_range
    @first_date = params.try(:fetch, :bling_order_item, nil).try(:fetch, :initial_date, nil).try(:to_date).try(:beginning_of_day) || Time.zone.today.beginning_of_day
    @second_date = params.try(:fetch, :bling_order_item, nil).try(:fetch, :final_date, nil).try(:to_date).try(:end_of_day) || Time.zone.today.end_of_day
    @date_range = @first_date.to_date.beginning_of_day..@second_date.end_of_day
  end

  def bling_order_items
    base_query = BlingOrderItem.where(situation_id: BlingOrderItem::Status::WITHOUT_CANCELLED,
                                      account_id: current_user.account.id)
                               .date_range(@first_date, @second_date)

    @bling_order_items = BlingOrderItem.group_order_items(base_query)
  end

  def get_in_progress_order_items
    @in_progress_order_items = BlingOrderItem.where(situation_id: BlingOrderItem::Status::IN_PROGRESS,
                                                    account_id: current_user.account.id)
  end

  def collected_orders
    base_query = BlingOrderItem.where(situation_id: BlingOrderItem::Status::COLLECTED,
                                      account_id: current_user.account.id, collected_alteration_date: @first_date..@second_date)
    @collected_orders = BlingOrderItem.group_order_items(base_query)
  end

  def finance_per_status
    @pendings = SheinOrder.where("data ->> 'Status do pedido' = ?", 'Pendente')
    @to_be_colected = SheinOrder.where("data ->> 'Status do pedido' = ?", 'Para ser coletado por SHEIN')
    @to_be_sent = SheinOrder.where("data ->> 'Status do pedido' = ?", 'Para ser enviado por SHEIN')
    @sent = SheinOrder.where("data ->> 'Status do pedido' = ?", 'Enviado')
  end

  def current_done_order_items
    base_query = BlingOrderItem.where(situation_id: [BlingOrderItem::Status::VERIFIED,
                                                     BlingOrderItem::Status::CHECKED],
                                      alteration_date: @date_range,
                                      account_id: current_user.account.id)
    @current_done_order_items = BlingOrderItem.group_order_items(base_query)
  end

  def get_printed_order_items
    @printed_order_items = BlingOrderItem.where(situation_id: BlingOrderItem::Status::PRINTED,
                                                account_id: current_user.account.id)
  end

  def get_pending_order_items
    @pending_order_items = BlingOrderItem.where(situation_id: BlingOrderItem::Status::PENDING,
                                                account_id: current_user.account.id)
  end

  def canceled_orders
    base_query = BlingOrderItem.where(situation_id: BlingOrderItem::Status::CANCELED,
                                      account_id: current_user.account.id)
                               .date_range(@first_date, @second_date)

    @canceled_orders = BlingOrderItem.group_order_items(base_query)
  end

  def set_monthly_revenue_estimation
    @monthly_revenue_estimation = RevenueEstimation.current_month.take
  end

  def count_mercado_envios_flex(order_ids)
    # TODO, get it from the database directly.
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

  def fetch_order_data(order_id)
    Services::Bling::FindOrder.call(id: order_id, order_command: 'find_order',
                                    tenant: current_user.account.id)
  end

  def format_last_update(time)
    time&.strftime('%d-%m-%Y %H:%M:%S')
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
