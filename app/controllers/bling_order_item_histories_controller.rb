# frozen_string_literal: true

# There is a necessity to know the revenue from the last 15 days
# In order to take better commercial decisions.
class BlingOrderItemHistoriesController < ApplicationController
  before_action :date_range, :paid_bling_order_items, :day_quantities_presenter,
                only: %i[day_quantities]
  before_action :daily_revenue, :canceled_revenue, only: :index

  def index;end

  def day_quantities
    render json: @paid_items_presentable
  end

  def daily_revenue
    @initial_date = params.dig('bling_order', 'initial_date') || Time.current.beginning_of_month.strftime('%Y-%m-%d')
    @final_date = params.dig('bling_order', 'final_date') || Time.current.end_of_month.strftime('%Y-%m-%d')
    @daily_date_range_filter = { initial_date: @initial_date, final_date: @final_date }
    @bling_order_items = BlingOrderItem.where(situation_id: [BlingOrderItem::Status::PAID],
                                              account_id: current_user.account.id)
    @date_order_items = @bling_order_items.where(date: @initial_date.to_time.beginning_of_day..@final_date.to_time.end_of_day)                               
    @quantity_paid = @date_order_items.count
    @revenue_paid = @date_order_items.sum(:value)
    @average_ticket = @revenue_paid / @quantity_paid
    average_orders
    @daily_revenue = DailyRevenueReport.new(@bling_order_items, @daily_date_range_filter).presentable
    @daily_revenue = @daily_revenue.last(30) # Limit to last 30 days
    @daily_revenue = @daily_revenue.to_json
  end

  def canceled_revenue
    @canceled_bling_order_items = BlingOrderItem.where(situation_id: [BlingOrderItem::Status::CANCELED],
                                              account_id: current_user.account.id)
    @canceled_revenue = DailyRevenueReport.new(@canceled_bling_order_items, @daily_date_range_filter).presentable
    @canceled_revenue = @canceled_revenue.last(30) # Limit to last 30 days
    @canceled_revenue = @canceled_revenue.to_json
  end

  private

  def date_range
    initial_date = (Date.today - 15.days).beginning_of_day
    final_date = Date.today.end_of_day
    @date_range = initial_date..final_date
  end

  def paid_bling_order_items
    @paid_bling_order_items = BlingOrderItem.where(date: date_range, situation_id: [BlingOrderItem::Status::PAID],
                                                   account_id: current_user.account.id)
  end

  def average_orders
    orders = paid_bling_order_items
    @sum_last_days = orders.count.to_i
    @average_last_days = @sum_last_days / 15
  end 

  def day_quantities_presenter
    @paid_items_presentable = BlingOrderItemHistoriesPresenter.new(@paid_bling_order_items).presentable
  end

  def prepare_chart_data(items, date_range)
    data = DailyRevenueReport.new(items, date_range).presentable
    data = data.last(30) # Limit to last 30 days
    {
      labels: data.map { |item| item[:x] },
      datasets: [
        { label: 'Shein', data: data.map { |item| item[:shein] } },
        { label: 'Shopee', data: data.map { |item| item[:shopee] } },
        { label: 'Simple 7', data: data.map { |item| item[:simple_7] } },
        { label: 'Mercado Livre', data: data.map { |item| item[:mercado_livre] } },
        { label: 'Feira da Madrugada', data: data.map { |item| item[:feira_madrugada] } },
        { label: 'Nuvem Shop', data: data.map { |item| item[:nuvem_shop] } },
        { label: 'Total', data: data.map { |item| item[:total] }, type: 'line' }
      ]
    }.to_json
  end
end
