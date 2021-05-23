class CreateSimploProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :simplo_products do |t|
      t.string :name
      t.string :sku

      t.timestamps
    end
  end
end
