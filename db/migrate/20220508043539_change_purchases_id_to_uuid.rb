class ChangePurchasesIdToUuid < ActiveRecord::Migration[7.0]
  def change
    remove_column :purchase_products, :purchase_id
    add_column :purchases, :uuid, :uuid
    rename_column :purchases, :id, :integer_id
    rename_column :purchases, :uuid, :id
    execute "ALTER TABLE purchases drop constraint purchases_pkey;"
    execute "ALTER TABLE purchases ADD PRIMARY KEY (id)"
    add_column :purchase_products, :purchase_id, :uuid, foreign_key: true
    add_index :purchase_products, :purchase_id
  end
end
