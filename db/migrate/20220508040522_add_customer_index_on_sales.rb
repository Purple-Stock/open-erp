class AddCustomerIndexOnSales < ActiveRecord::Migration[7.0]
  def change
    add_index :sales, :customer_id
  end
end
