# frozen_string_literal: true

class AddSkuToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :sku, :string
  end
end
