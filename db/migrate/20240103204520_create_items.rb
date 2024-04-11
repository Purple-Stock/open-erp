class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :sku
      t.integer :unity
      t.integer :quantity
      t.decimal :discount
      t.decimal :value
      t.decimal :ipi_tax
      t.string :description
      t.string :long_description
      t.bigint :product_id
      t.integer :account_id
      t.bigint :bling_order_item_id

      t.timestamps
    end
  end
end
