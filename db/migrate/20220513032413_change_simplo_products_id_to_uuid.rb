class ChangeSimploProductsIdToUuid < ActiveRecord::Migration[7.0]
  def change
    add_column :simplo_products, :uuid, :uuid

    rename_column :simplo_products, :id, :integer_id
    rename_column :simplo_products, :uuid, :id

    execute 'ALTER TABLE simplo_products drop constraint simplo_products_pkey'
    execute 'ALTER TABLE simplo_products ADD PRIMARY KEY (id)'
  end
end
