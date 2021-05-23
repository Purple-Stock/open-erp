class AddStoreSaleToSales < ActiveRecord::Migration[6.0]
  def change
    add_column :sales, :store_sale, :integer, default: 0
  end
end
