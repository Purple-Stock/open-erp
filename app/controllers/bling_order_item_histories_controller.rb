# frozen_string_literal: true

# There is a necessity to know the revenue from the last 15 days
# In order to take better commercial decisions.
class BlingOrderItemHistoriesController < ApplicationController
  before_action :date_range, :paid_bling_order_items, :day_quantities_presenter,
                only: %i[day_quantities]

  def index;end

  def day_quantities
    render json: @paid_items_presentable
  end

  def monthly_revenue
    @current_year = Date.current.beginning_of_year..Date.current.end_of_day
    @bling_order_items = BlingOrderItem.where(date: @current_year, situation_id: [BlingOrderItem::Status::PAID],
                                              account_id: current_user.account.id)
    @monthly_revenue = MonthlyRevenuePresenter.new(@bling_order_items).presentable
    render json: @monthly_revenue
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

  def day_quantities_presenter
    @paid_items_presentable = BlingOrderItemHistoriesPresenter.new(@paid_bling_order_items).presentable
  end
end
