class AddAccountToSheinOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :shein_orders, :account_id, :integer
    add_index :shein_orders, :account_id 
  end
end
