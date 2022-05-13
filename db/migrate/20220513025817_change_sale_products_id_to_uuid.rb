class ChangeSaleProductsIdToUuid < ActiveRecord::Migration[7.0]
  def change
    add_column :sale_products, :uuid, :uuid

    rename_column :sale_products, :id, :integer_id
    rename_column :sale_products, :uuid, :id

    execute 'ALTER TABLE sale_products drop constraint sale_products_pkey'
    execute 'ALTER TABLE sale_products ADD PRIMARY KEY (id)'
  end
end
