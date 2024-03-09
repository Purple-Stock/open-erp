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
    @items = BlingOrderItem.includes(:items)
                      .where(created_at: (15.days.ago..Time.now))
                      .where(account_id: current_tenant.id)
                      .joins(:items)
                      .group('bling_order_items.id', 'items.sku', 'items.id')
                      .select('items.sku, sum(items.quantity) as total_quantity')
  end
end
