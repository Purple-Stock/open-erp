class AddItemsToBlingOrderItem < ActiveRecord::Migration[7.0]
  def change
    add_column :bling_order_items, :items, :jsonb
  end
end
