class ChangeSimploItemIdToUuid < ActiveRecord::Migration[7.0]
  def change
    add_column :simplo_items, :uuid, :uuid, default: "gen_random_uuid()", null: false

    rename_column :simplo_items, :id, :integer_id
    rename_column :simplo_items, :uuid, :id

    execute 'ALTER TABLE simplo_items drop constraint simplo_items_pkey'
    execute 'ALTER TABLE simplo_items ADD PRIMARY KEY (id)'
  end
end
