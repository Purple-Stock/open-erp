class AddAccountIdToStock < ActiveRecord::Migration[7.0]
  def change
    add_column :stocks, :account_id, :integer
  end
end
