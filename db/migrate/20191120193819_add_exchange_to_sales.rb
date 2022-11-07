# frozen_string_literal: true

class AddExchangeToSales < ActiveRecord::Migration[6.0]
  def change
    add_column :sales, :exchange, :boolean, default: false
  end
end
