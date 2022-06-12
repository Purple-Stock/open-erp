class ChangeAccountIdToUuid < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :categories, :account_id, :integer_id
    rename_column :categories, :uuid, :account_id

    add_column :products, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :products, :account_id, :integer_id
    rename_column :products, :uuid, :account_id

    add_column :customers, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :customers, :account_id, :integer_id
    rename_column :customers, :uuid, :account_id

    add_column :sales, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :sales, :account_id, :integer_id
    rename_column :sales, :uuid, :account_id

    add_column :sale_products, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :sale_products, :account_id, :integer_id
    rename_column :sale_products, :uuid, :account_id

    add_column :purchase_products, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :purchase_products, :account_id, :integer_id
    rename_column :purchase_products, :uuid, :account_id

    add_column :suppliers, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_column :purchases, :account_id, :uuid
  end
end
