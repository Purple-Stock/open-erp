# frozen_string_literal: true

class ReportsController < ApplicationController
  def daily_sale
    @total_daily = Sale.find_by_sql("SELECT s.created_at::DATE, SUM(s.value) AS value, SUM(s.discount) AS discount
                                    FROM sales s
                                    WHERE exchange = FALSE AND account_id = #{current_tenant.id}
                                    GROUP BY s.created_at::DATE
                                    ORDER BY s.created_at::DATE DESC;")

    @exchange_daily = Sale.find_by_sql("SELECT s.created_at::DATE, SUM(s.total_exchange_value) AS total_exchange_value
                                        FROM sales s
                                        WHERE exchange = TRUE AND account_id = #{current_tenant.id}
                                        GROUP BY s.created_at::DATE
                                        ORDER BY s.created_at::DATE DESC;")
  end

  def all_reports; end

  def payment; end

  def top_selling_products
    if params[:selling_products] && params[:selling_products][:initial_date].present?
      @initial_date = params[:selling_products][:initial_date]
    end
    if params[:selling_products] && params[:selling_products][:final_date].present?
      @final_date = params[:selling_products][:final_date]
    end

    @items = Item.joins(bling_order_item: :items)
                 .where(bling_order_items: { date: date_range })
                 .where(bling_order_items: { situation_id: [BlingOrderItem::Status::PAID] })
                 .where(account_id: current_tenant.id)
                 .group('items.sku')
                 .select('items.sku, SUM(items.quantity) AS total_quantity')
                 .order('total_quantity DESC')
  end

  private

  def date_range
    if params[:selling_products].present? && params[:selling_products][:initial_date].present? && params[:selling_products][:final_date].present?
      initial_date = params[:selling_products][:initial_date].to_date.beginning_of_day
      final_date = params[:selling_products][:final_date].to_date.end_of_day
    else
      initial_date = (Date.today - 7.days).beginning_of_day
      final_date = Date.today.end_of_day
    end
    @date_range = initial_date..final_date
  end
end
