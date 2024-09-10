class CreateBalances < ActiveRecord::Migration[7.0]
  def change
    create_table :balances do |t|
      t.bigint :deposit_id, null: false
      t.integer :physical_balance, null: false
      t.integer :virtual_balance, null: false
      t.references :stock, null: false, foreign_key: true

      t.timestamps
    end
    add_index :balances, [:stock_id, :deposit_id], unique: true
  end
end
