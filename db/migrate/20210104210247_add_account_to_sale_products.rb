class AddAccountToSaleProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :sale_products, :account_id, :integer
    add_index :sale_products, :account_id
  end
end
