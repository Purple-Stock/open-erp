# frozen_string_literal: true

class AddAccountToSales < ActiveRecord::Migration[6.0]
  def change
    add_column :sales, :account_id, :integer
    add_index :sales, :account_id
  end
end
