# frozen_string_literal: true

class CreateSimploOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :simplo_orders do |t|
      t.string :client_name
      t.string :order_id
      t.string :order_status
      t.string :order_date

      t.timestamps
    end
  end
end
