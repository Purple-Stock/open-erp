class ChangeSupplierIdToUuid < ActiveRecord::Migration[7.0]
  def change
    remove_column :purchases, :supplier_id

    add_column :suppliers, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :suppliers, :id, :integer_id
    rename_column :suppliers, :uuid, :id

    execute 'ALTER TABLE suppliers drop constraint suppliers_pkey'
    execute 'ALTER TABLE suppliers ADD PRIMARY KEY (id)'

    add_column :purchases, :supplier_id, :uuid, foreign_key: true
    add_index :purchases, :supplier_id
  end
end
