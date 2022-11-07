# frozen_string_literal: true

class AddAccountToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :account_id, :integer
    add_index :customers, :account_id
  end
end
