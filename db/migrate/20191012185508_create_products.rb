# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.string :bar_code
      t.string :image_url
      t.boolean :highlight
      t.references :category, foreign_key: true
      t.boolean :active

      t.timestamps
    end
  end
end
