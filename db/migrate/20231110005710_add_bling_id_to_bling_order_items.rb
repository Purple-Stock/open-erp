class AddBlingIdToBlingOrderItems < ActiveRecord::Migration[7.0]
  def change
    add_column :bling_order_items, :bling_id, :integer
  end
end
