# frozen_string_literal: true

class CreateGroupProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :group_products do |t|
      t.references :group, foreign_key: true
      t.references :product, foreign_key: true
      t.timestamps
    end
  end
end
