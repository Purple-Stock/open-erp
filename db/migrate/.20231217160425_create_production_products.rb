class CreateProductionProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :production_products do |t|
      t.references :production, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
