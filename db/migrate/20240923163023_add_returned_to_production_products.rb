class AddReturnedToProductionProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :production_products, :returned, :boolean, default: false
  end
end