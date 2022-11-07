# frozen_string_literal: true

class AddOrderCodeToSales < ActiveRecord::Migration[6.0]
  def change
    add_column :sales, :order_code, :string
  end
end
