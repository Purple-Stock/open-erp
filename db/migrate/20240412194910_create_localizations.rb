class CreateLocalizations < ActiveRecord::Migration[7.0]
  def change
    create_table :localizations do |t|
      t.string :name
      t.string :address
      t.string :number
      t.string :complement
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :neighborhood
      t.string :country_name
      t.integer :account_id
      t.bigint :bling_order_item_id

      t.timestamps
    end
  end
end
