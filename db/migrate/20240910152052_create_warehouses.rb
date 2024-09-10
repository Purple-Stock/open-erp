class CreateWarehouses < ActiveRecord::Migration[7.0]
  def change
    create_table :warehouses do |t|
      t.string :bling_id, null: false
      t.string :description, null: false
      t.integer :status, null: false, default: 1
      t.boolean :is_default, null: false, default: false
      t.boolean :ignore_balance, null: false, default: false
      t.integer :account_id

      t.timestamps
    end

    add_index :warehouses, [:bling_id, :account_id], unique: true
    add_index :warehouses, :status
  end
end