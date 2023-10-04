class AddDateToBlingOrderItem < ActiveRecord::Migration[7.0]
  def change
    add_column :bling_order_items, :date, :datetime
  end
end
