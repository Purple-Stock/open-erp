class ChangePurchaseProductsIdToUuid < ActiveRecord::Migration[7.0]
  def change
    add_column :purchase_products, :uuid, :uuid
    rename_column :purchase_products, :id, :integer_id
    rename_column :purchase_products, :uuid, :id

    execute 'ALTER TABLE purchase_products drop constraint purchase_products_pkey'
    execute 'ALTER TABLE purchase_products ADD PRIMARY KEY (id)'
  end
end
