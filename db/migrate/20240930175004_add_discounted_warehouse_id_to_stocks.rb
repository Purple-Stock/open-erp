class AddDiscountedWarehouseIdToStocks < ActiveRecord::Migration[6.1]
  def change
    add_column :stocks, :discounted_warehouse_sku_id, :string
  end
end