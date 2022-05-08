class AddIdOnCustomers < ActiveRecord::Migration[7.0]
  def change
    remove_column :sales, :customer_id
    add_column :customers, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :customers, :id, :integer_id
    rename_column :customers, :uuid, :id
    execute "ALTER TABLE customers drop constraint customers_pkey;"
    execute 'ALTER TABLE customers ADD PRIMARY KEY (id);'
    add_column :sales, :customer_id, :uuid
  end
end
