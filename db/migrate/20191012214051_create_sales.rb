# frozen_string_literal: true

class CreateSales < ActiveRecord::Migration[6.0]
  def change
    create_table :sales do |t|
      t.float :value
      t.float :discount
      t.float :percentage
      t.boolean :online
      t.boolean :disclosure
      t.references :customer, foreign_key: true

      t.timestamps
    end
  end
end
