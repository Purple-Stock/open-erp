class AddIdOnAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :uuid, :uuid, default: "gen_random_uuid()", null: false
    rename_column :accounts, :id, :integer_id
    rename_column :accounts, :uuid, :id
    execute "ALTER TABLE accounts drop constraint accounts_pkey;"
    execute 'ALTER TABLE accounts ADD PRIMARY KEY (id);'
  end
end
