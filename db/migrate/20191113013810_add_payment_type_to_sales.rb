# frozen_string_literal: true

class AddPaymentTypeToSales < ActiveRecord::Migration[6.0]
  def change
    add_column :sales, :payment_type, :integer, default: 0
  end
end
