# frozen_string_literal: true

class AddAccountToPurchaseProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :purchase_products, :account_id, :integer
    add_index :purchase_products, :account_id
  end
end
