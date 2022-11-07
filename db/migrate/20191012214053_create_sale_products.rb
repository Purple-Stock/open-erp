# frozen_string_literal: true

class CreateSaleProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :sale_products do |t|
      t.integer :quantity
      t.float :value
      t.references :product, foreign_key: true
      t.references :sale, foreign_key: true

      t.timestamps
    end
  end
end
