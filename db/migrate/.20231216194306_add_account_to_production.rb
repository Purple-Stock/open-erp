class AddAccountToProduction < ActiveRecord::Migration[7.0]
  def change
    add_column :productions, :account_id, :integer
    add_index :productions, :account_id
  end
end
