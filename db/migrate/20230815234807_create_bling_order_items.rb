class CreateBlingOrderItems < ActiveRecord::Migration[7.0]
  def change
    create_table :bling_order_items do |t|
      t.string :bling_order_id
      t.string :codigo
      t.string :unidade
      t.integer :quantidade
      t.decimal :desconto
      t.decimal :valor
      t.decimal :aliquotaIPI
      t.text :descricao
      t.text :descricaoDetalhada
      t.string :situation_id
      t.string :store_id 

      t.timestamps
    end
  end
end
