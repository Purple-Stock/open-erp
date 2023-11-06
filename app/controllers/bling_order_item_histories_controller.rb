# frozen_string_literal: true

# There is a necessity to know the revenue from the last 15 days
# In order to take better commercial decisions.
class BlingOrderItemHistoriesController < ApplicationController
  def index;end

  def day_quantities
    # TODO, separate responsibilities: the presenter pattern
    initial_date = (Date.today - 15.days).beginning_of_day
    final_date = Date.today.end_of_day
    date_range = initial_date..final_date
    @paid_bling_order_items = BlingOrderItem.where(date: date_range, situation_id: [BlingOrderItem::Status::PAID])
                                            .group(:date).count


    result = @paid_bling_order_items.map do |day_quantity|
      { day: day_quantity.dig(0).day, quantity: day_quantity.dig(1) }
    end

    render json: result
  end
end
