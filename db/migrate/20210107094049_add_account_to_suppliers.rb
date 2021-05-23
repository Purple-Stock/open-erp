class AddAccountToSuppliers < ActiveRecord::Migration[6.0]
  def change
    add_column :suppliers, :account_id, :integer
    add_index :suppliers, :account_id
  end
end
