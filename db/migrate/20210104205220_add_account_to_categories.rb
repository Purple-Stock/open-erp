class AddAccountToCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :account_id, :integer
    add_index :categories, :account_id
  end
end
