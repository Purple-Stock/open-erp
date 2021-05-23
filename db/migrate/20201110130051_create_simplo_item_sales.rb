class CreateSimploItemSales < ActiveRecord::Migration[6.0]
  def change
    create_table :simplo_item_sales do |t|
      t.string :produto_id
      t.string :sku
      t.string :nome_produto
      t.integer :quantidade
      t.float :valor_unitario
      t.float :valor_total
      t.float :peso
      t.float :desconto
      t.datetime :data_pedido

      t.timestamps
    end
  end
end
