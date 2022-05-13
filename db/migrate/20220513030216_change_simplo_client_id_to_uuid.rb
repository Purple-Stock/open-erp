class ChangeSimploClientIdToUuid < ActiveRecord::Migration[7.0]
  def change
    add_column :simplo_clients, :uuid, :uuid

    rename_column :simplo_clients, :id, :integer_id
    rename_column :simplo_clients, :uuid, :id

    execute 'ALTER TABLE simplo_clients drop constraint simplo_clients_pkey'
    execute 'ALTER TABLE simplo_clients ADD PRIMARY KEY (id)'
  end
end
