require 'csv'

class DashboardsController < ApplicationController
  before_action :token_expires_at, :date_range, :bling_order_items, :canceled_orders, :get_in_progress_order_items,
                :current_done_order_items, :set_monthly_revenue_estimation, :get_printed_order_items,
                :get_pending_order_items, :collected_orders, only: [:others_status, :metas_report]
  before_action :set_date_range, :set_account, only: [:status_summary]

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

    @grouped_printed_order_items = BlingOrderItem.group_order_items(@printed_order_items || [])
    @grouped_pending_order_items = BlingOrderItem.group_order_items(@pending_order_items || [])
    @grouped_in_progress_order_items = BlingOrderItem.group_order_items(@in_progress_order_items || [])

    # Add this line to ensure @order_items is always a hash
    @order_items = {}
  end

  def revenue_target_report
    @monthly_revenue_estimation = RevenueEstimation.current_month.take
    
    if @monthly_revenue_estimation.present?
      @initial_date = Date.today.beginning_of_month
      @final_date = Date.today

      @bling_order_items = BlingOrderItem.where(situation_id: BlingOrderItem::Status::PAID,
                                                account_id: current_user.account.id)
      @date_order_items = @bling_order_items.where(date: @initial_date.to_time.beginning_of_day..@final_date.to_time.end_of_day)                               
      @current_month_count = @date_order_items.count

      @ratio = calculate_ratio(@current_month_count, @monthly_revenue_estimation.quantity)
      
      # Calculate daily quantity
      @daily_quantity = (@monthly_revenue_estimation.quantity / Date.today.end_of_month.day).round(2)

      # Calculate today's sales
      @today_sales = @bling_order_items.where(date: Date.today.beginning_of_day..Date.today.end_of_day).count

      # Calculate the ratio of today's sales to daily target
      @daily_ratio = calculate_ratio(@today_sales, @daily_quantity)

      # Calculate total revenue for the current month
      @current_month_revenue = @date_order_items.sum(:value)

      # Calculate current average ticket
      @current_average_ticket = @current_month_count > 0 ? (@current_month_revenue / @current_month_count).round(2) : 0
    end
  end

  def status_summary
    set_date_range
    set_account

    @statuses = [
      { name: "Em andamento (Pagos)", items: grouped_in_progress_order_items },
      { name: "Atendidos", items: grouped_fulfilled_order_items },
      { name: "Impressos", items: grouped_printed_order_items },
      { name: "Pendentes", items: grouped_pending_order_items },
      { name: "Pedidos a enviar", items: pedidos_a_enviar },
      { name: "Feitos (checados e verificados)", items: current_done_order_items },
      { name: "Coletados", items: collected_orders },
      { name: "Cancelados", items: canceled_orders },
      { name: "Com erro", items: grouped_error_order_items }
    ]

    respond_to do |format|
      format.html
      format.csv { send_data generate_csv, filename: "status_summary_#{Date.today}.csv" }
    end
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
    group_order_items(BlingOrderItem.where(situation_id: BlingOrderItem::Status::COLLECTED,
                                         account_id: @account_id)
                                  .flexible_date_range(@first_date, @second_date))
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
    group_order_items(BlingOrderItem.where(situation_id: BlingOrderItem::Status::CANCELED,
                                         account_id: @account_id)
                                  .flexible_date_range(@first_date, @second_date))
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

  def calculate_ratio(current_count, target_count)
    return 0 if target_count.to_i.zero?
    (current_count.to_f / target_count * 100).round(2)
  end

  def set_date_range
    @default_initial_date = params[:initial_date].presence || Time.zone.today.to_date
    @default_final_date = params[:final_date].presence || Time.zone.today.to_date

    @first_date = @default_initial_date
    @second_date = @default_final_date

    @date_range = @first_date.beginning_of_day..@second_date.end_of_day
  end

  def set_account
    @account_id = current_user.account.id
  end

  def grouped_in_progress_order_items
    group_order_items(BlingOrderItem.where(situation_id: BlingOrderItem::Status::IN_PROGRESS, account_id: @account_id))
  end

  def grouped_printed_order_items
    group_order_items(BlingOrderItem.where(situation_id: BlingOrderItem::Status::PRINTED, account_id: @account_id))
  end

  def grouped_pending_order_items
    group_order_items(BlingOrderItem.where(situation_id: BlingOrderItem::Status::PENDING, account_id: @account_id))
  end

  def grouped_fulfilled_order_items
    group_order_items(BlingOrderItem.where(situation_id: BlingOrderItem::Status::FULFILLED, account_id: @account_id))
  end

  def grouped_error_order_items
    group_order_items(BlingOrderItem.where(situation_id: BlingOrderItem::Status::ERROR, account_id: @account_id))
  end

  def pedidos_a_enviar
    statuses = [
      BlingOrderItem::Status::IN_PROGRESS,
      BlingOrderItem::Status::FULFILLED,
      BlingOrderItem::Status::PRINTED,
      BlingOrderItem::Status::PENDING
    ]
    
    orders = BlingOrderItem.where(situation_id: statuses, account_id: @account_id)
    group_order_items(orders)
  end

  def group_order_items(base_query)
    grouped_order_items = {}
    BlingOrderItem::STORE_NAME_KEY_VALUE.each_value { |store| grouped_order_items[store] = [] }

    grouped_order_items.merge!(
      base_query.group_by(&:store_id)
                .transform_keys { |store_id| BlingOrderItem::STORE_NAME_KEY_VALUE.fetch(store_id, 'Outros') }
    )
  end

  def generate_csv
    CSV.generate(headers: true) do |csv|
      csv << ['Status', 'Shein', 'Shopee', 'Mercado Livre', 'Nuvem Shop', 'Total']

      @statuses.each do |status|
        row = [status[:name]]
        if status[:items].present?
          row << (status[:items]['Shein']&.count || 0)
          row << (status[:items]['Shopee']&.count || 0)
          row << (status[:items]['Mercado Livre']&.count || 0)
          row << (status[:items]['Nuvem Shop']&.count || 0)
          row << status[:items].values.sum(&:count)
        else
          row += [0, 0, 0, 0, 0]
        end
        csv << row
      end
    end
  end
end