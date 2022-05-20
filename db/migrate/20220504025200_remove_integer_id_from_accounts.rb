class RemoveIntegerIdFromAccounts < ActiveRecord::Migration[7.0]
  def change
    remove_column :accounts, :integer_id
  end
end
