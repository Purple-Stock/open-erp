class ChangeGroupProductIdToUuid < ActiveRecord::Migration[7.0]
  def change
    add_column :group_products, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :group_products, :id, :integer_id
    rename_column :group_products, :uuid, :id

    execute 'ALTER TABLE group_products drop constraint group_products_pkey'
    execute 'ALTER TABLE group_products ADD PRIMARY KEY (id)'
  end
end
