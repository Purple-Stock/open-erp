class ChangeSalesIdToUuid < ActiveRecord::Migration[7.0]
  def change
    remove_column :sale_products, :sale_id

    add_column :sales, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :sales, :id, :integer_id
    rename_column :sales, :uuid, :id

    execute 'ALTER TABLE sales drop constraint sales_pkey'
    execute 'ALTER TABLE sales ADD PRIMARY KEY (id)'

    add_column :sale_products, :sale_id, :uuid, foreign_key: true
    add_index :sale_products, :sale_id
  end
end
