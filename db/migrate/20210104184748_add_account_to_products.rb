class AddAccountToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :account_id, :integer
    add_index :products, :account_id
  end
end
