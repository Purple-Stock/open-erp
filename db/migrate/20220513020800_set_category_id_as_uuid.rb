class SetCategoryIdAsUuid < ActiveRecord::Migration[7.0]
  def change
    remove_column :products, :category_id

    add_column :categories, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :categories, :id, :integer_id
    rename_column :categories, :uuid, :id

    execute 'ALTER TABLE categories drop constraint categories_pkey'
    execute 'ALTER TABLE categories ADD PRIMARY KEY (id)'

    add_column :products, :category_id, :uuid, foreign_key: true

    add_index :products, :category_id

    add_foreign_key :products, :categories
  end
end
