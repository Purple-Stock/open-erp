class AddMaterialCostsToProductions < ActiveRecord::Migration[7.0]
  def change
    add_column :productions, :notions_cost, :decimal, precision: 10, scale: 2
    add_column :productions, :fabric_cost, :decimal, precision: 10, scale: 2
  end
end
