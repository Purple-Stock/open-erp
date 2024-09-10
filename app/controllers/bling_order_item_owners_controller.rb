# frozen_string_literal: true

# There is a necessity to know the revenue from the last 15 days
# In order to take better commercial decisions.
class BlingOrderItemOwnersController < ApplicationController
  before_action :date_range, :paid_bling_order_items, :day_quantities_presenter,
                only: %i[day_quantities]
  before_action :daily_revenue, only: :index

  def index; end

  def verification
    @printed_order_items = BlingOrderItem.where(situation_id: BlingOrderItem::Status::PRINTED,
                                                account_id: current_user.account.id)

    @grouped_printed_order_items = BlingOrderItem.selected_group_order_items(@printed_order_items)

    @fulfilled_order_items = BlingOrderItem.where(situation_id: BlingOrderItem::Status::FULFILLED,
                                                          account_id: current_user.account.id)
    
    @grouped_fulfilled_order_items = BlingOrderItem.selected_group_order_items(@fulfilled_order_items)

    @in_progress_order_items = BlingOrderItem.where(situation_id: BlingOrderItem::Status::IN_PROGRESS,
                                                    account_id: current_user.account.id)

    @grouped_in_progress_order_items = BlingOrderItem.selected_group_order_items(@in_progress_order_items)

    @pending_order_items = BlingOrderItem.where(situation_id: BlingOrderItem::Status::PENDING,
                                                account_id: current_user.account.id)

    @grouped_pending_order_items = BlingOrderItem.selected_group_order_items(@pending_order_items)

    @current_done_order_items = BlingOrderItem.where(situation_id: [BlingOrderItem::Status::VERIFIED,
                                                                    BlingOrderItem::Status::CHECKED],
                                                     alteration_date: Time.current.beginning_of_day..Time.current.end_of_day,
                                                     account_id: current_user.account.id).count
    @colected_orders = BlingOrderItem.where(situation_id: BlingOrderItem::Status::COLLECTED,
                                            account_id: current_user.account.id, collected_alteration_date: Time.current.beginning_of_day..Time.current.end_of_day).count
  end

  def day_quantities
    render json: @paid_items_presentable
  end

  def daily_revenue
    @printed_order_items = BlingOrderItem.where(situation_id: BlingOrderItem::Status::PRINTED,
                                                account_id: current_user.account.id).count
    @in_progress_order_items = BlingOrderItem.where(situation_id: BlingOrderItem::Status::IN_PROGRESS,
                                                    account_id: current_user.account.id).count
    @pending_order_items = BlingOrderItem.where(situation_id: BlingOrderItem::Status::PENDING,
                                                account_id: current_user.account.id).count
    @fulfilled_order_items = BlingOrderItem.where(situation_id: BlingOrderItem::Status::FULFILLED,
                                                  account_id: current_user.account.id).count
    @current_done_order_items = BlingOrderItem.where(situation_id: [BlingOrderItem::Status::VERIFIED,
                                                                    BlingOrderItem::Status::CHECKED],
                                                     alteration_date: Time.current.beginning_of_day..Time.current.end_of_day,
                                                     account_id: current_user.account.id).count
    @colected_orders = BlingOrderItem.where(situation_id: BlingOrderItem::Status::COLLECTED,
                                            account_id: current_user.account.id, collected_alteration_date: Time.current.beginning_of_day..Time.current.end_of_day).count

    @initial_date = params.fetch('bling_order',
                                 initial_date: Time.current.strftime('%Y-%m-%d %H:%M')).fetch('initial_date')
    @final_date = params.fetch('bling_order', final_date: Time.current.strftime('%Y-%m-%d %H:%M')).fetch('final_date')
    @daily_date_range_filter = { initial_date: @initial_date, final_date: @final_date }
    @bling_order_items = BlingOrderItem.where(situation_id: [BlingOrderItem::Status::PAID],
                                              account_id: current_user.account.id)
    monthly_revenue
    anual_revenue
    @date_order_items = @bling_order_items.where(date: @initial_date.to_datetime.beginning_of_day..@final_date.to_datetime.end_of_day)
    @quantity_paid = @date_order_items.count
    @revenue_paid = @date_order_items.sum(:value)
    @average_ticket = @revenue_paid / @quantity_paid
    @daily_revenue = DailyRevenueReport.new(@bling_order_items, @daily_date_range_filter).presentable
    @daily_revenue = @daily_revenue.to_json
  end

  private

  def monthly_revenue
    @initial_monthly_date = Time.zone.now.beginning_of_month
    @final_monthly_date = Time.zone.now
    @monthly_order_items = @bling_order_items.where(date: @initial_monthly_date..@final_monthly_date)
    @monthly_quantity_paid = @monthly_order_items.count
    @monthly_revenue_paid = @monthly_order_items.sum(:value)
    @monthly_average_ticket = @monthly_revenue_paid / @monthly_quantity_paid
  end

  def anual_revenue
    @initial_anual_date = Time.zone.now.beginning_of_year
    @final_anual_date = Time.zone.now
    @anual_order_items = @bling_order_items.where(date: @initial_anual_date..@final_anual_date)
    @anual_quantity_paid = @anual_order_items.count
    @anual_revenue_paid = @anual_order_items.sum(:value)
    @anual_average_ticket = @anual_revenue_paid / @anual_quantity_paid
  end

  def date_range
    initial_date = (Date.today - 15.days).beginning_of_day
    final_date = Date.today.end_of_day
    @date_range = initial_date..final_date
  end

  def paid_bling_order_items
    @paid_bling_order_items = BlingOrderItem.where(date: date_range, situation_id: [BlingOrderItem::Status::PAID],
                                                   account_id: current_user.account.id)
  end

  def day_quantities_presenter
    @paid_items_presentable = BlingOrderItemHistoriesPresenter.new(@paid_bling_order_items).presentable
  end
end
