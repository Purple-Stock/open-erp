class AddAccountToTailor < ActiveRecord::Migration[7.0]
  def change
    add_column :tailors, :account_id, :integer
    add_index :tailors, :account_id
  end
end
