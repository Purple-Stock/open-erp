class AddFieldsToProductionProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :production_products, :dirty, :integer, default: 0
    add_column :production_products, :error, :integer, default: 0
    add_column :production_products, :discard, :integer, default: 0
  end
end
