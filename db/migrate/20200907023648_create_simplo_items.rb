# frozen_string_literal: true

class CreateSimploItems < ActiveRecord::Migration[6.0]
  def change
    create_table :simplo_items do |t|
      t.string :sku
      t.integer :quantity
      t.references :simplo_order, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
