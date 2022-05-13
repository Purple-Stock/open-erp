class ChangeSimploOrderIdToUuid < ActiveRecord::Migration[7.0]
  def change
    remove_column :simplo_items, :simplo_order_id

    add_column :simplo_orders, :uuid, :uuid
    rename_column :simplo_orders, :id, :integer_id
    rename_column :simplo_orders, :uuid, :id

    execute 'ALTER TABLE simplo_orders drop constraint simplo_orders_pkey'
    execute 'ALTER TABLE simplo_orders ADD PRIMARY KEY (id)'

    add_column :simplo_items, :simplo_order_id, :uuid, foreign_key: true
    add_index :simplo_items, :simplo_order_id
  end
end
