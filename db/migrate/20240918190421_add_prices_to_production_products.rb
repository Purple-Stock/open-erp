class AddPricesToProductionProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :production_products, :unit_price, :decimal, precision: 10, scale: 2
    add_column :production_products, :total_price, :decimal, precision: 10, scale: 2
  end
end
