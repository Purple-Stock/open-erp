class ChangeSimploItemSalesIdToUuid < ActiveRecord::Migration[7.0]
  def change
    add_column :simplo_item_sales, :uuid, :uuid

    rename_column :simplo_item_sales, :id, :integer_id
    rename_column :simplo_item_sales, :uuid, :id

    execute 'ALTER TABLE simplo_item_sales drop constraint simplo_item_sales_pkey'
    execute 'ALTER TABLE simplo_item_sales ADD PRIMARY KEY (id)'
  end
end
