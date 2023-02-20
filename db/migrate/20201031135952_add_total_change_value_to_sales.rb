# frozen_string_literal: true

class AddTotalChangeValueToSales < ActiveRecord::Migration[6.0]
  def change
    add_column :sales, :total_exchange_value, :float
  end
end
