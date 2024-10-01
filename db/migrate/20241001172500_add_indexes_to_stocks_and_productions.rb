class AddIndexesToStocksAndProductions < ActiveRecord::Migration[6.1]
  def change
    add_index :stocks, :account_id unless index_exists?(:stocks, :account_id)
    add_index :stocks, :product_id unless index_exists?(:stocks, :product_id)
    add_index :productions, :confirmed unless index_exists?(:productions, :confirmed)
    add_index :production_products, :product_id unless index_exists?(:production_products, :product_id)
    add_index :production_products, :production_id unless index_exists?(:production_products, :production_id)
    add_index :items, :sku unless index_exists?(:items, :sku)
    add_index :bling_order_items, :date unless index_exists?(:bling_order_items, :date)
  end
end
