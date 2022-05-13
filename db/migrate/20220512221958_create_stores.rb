class CreateStores < ActiveRecord::Migration[7.0]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :email
      t.integer :account_id

      t.timestamps
    end

    add_index :stores, :account_id
  end
end
