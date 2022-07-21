class ChangeGroupProductsIdToUuid < ActiveRecord::Migration[7.0]
  def change
    remove_column :group_products, :group_id
    remove_column :group_products, :product_id
    remove_column :purchase_products, :product_id
    remove_column :sale_products, :product_id
    remove_column :simplo_items, :product_id

    add_column :groups, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :groups, :id, :integer_id
    rename_column :groups, :uuid, :id

    execute "ALTER TABLE groups drop constraint groups_pkey"
    execute "ALTER TABLE groups ADD PRIMARY KEY (id)"

    add_column :products, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :products, :id, :integer_id
    rename_column :products, :uuid, :id

    execute "ALTER TABLE products drop constraint products_pkey"
    execute "ALTER TABLE products ADD PRIMARY KEY (id)"

    add_column :group_products, :group_id, :uuid, foreign_key: true
    add_column :group_products, :product_id, :uuid, foreign_key: true
    add_column :purchase_products, :product_id, :uuid, foreign_key: true
    add_column :sale_products, :product_id, :uuid, foreign_key: true
    add_column :simplo_items, :product_id, :uuid, foreign_key: true

    add_index :group_products, :group_id
    add_index :group_products, :product_id
    add_index :purchase_products, :product_id
    add_index :sale_products, :product_id
    add_index :simplo_items, :product_id

    add_foreign_key :group_products, :groups
    add_foreign_key :group_products, :products
    add_foreign_key :purchase_products, :products
    add_foreign_key :sale_products, :products
    add_foreign_key :simplo_items, :products
  end
end
