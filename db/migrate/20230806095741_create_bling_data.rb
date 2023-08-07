class CreateBlingData < ActiveRecord::Migration[7.0]
  def change
    create_table :bling_data do |t|
      t.string :access_token
      t.integer :expires_in
      t.datetime :expires_at
      t.string :token_type
      t.text :scope
      t.string :refresh_token
      t.integer :account_id

      t.timestamps
    end

    add_index :bling_data, :account_id
  end
end
