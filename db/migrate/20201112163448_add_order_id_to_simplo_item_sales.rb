# frozen_string_literal: true

class AddOrderIdToSimploItemSales < ActiveRecord::Migration[6.0]
  def change
    add_column :simplo_item_sales, :order_id, :string
  end
end
