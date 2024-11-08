class AddEstruturaToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :tipo_estoque, :string
    add_column :products, :lancamento_estoque, :string
    add_column :products, :componentes, :jsonb
  end
end
