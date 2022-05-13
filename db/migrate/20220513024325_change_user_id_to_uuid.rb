class ChangeUserIdToUuid < ActiveRecord::Migration[7.0]
  def change
    remove_column :accounts, :user_id

    add_column :users, :uuid, :uuid
    rename_column :users, :id, :integer_id
    rename_column :users, :uuid, :id

    execute 'ALTER TABLE users drop constraint users_pkey'
    execute 'ALTER TABLE users ADD PRIMARY KEY (id)'

    add_column :accounts, :user_id, :uuid, foreign_key: true
    add_index :accounts, :user_id
  end
end
