class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.integer :product_id
      t.bigint :bling_product_id
      t.integer :total_balance
      t.integer :total_virtual_balance

      t.timestamps
    end
  end
end
