class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.decimal :amount
      t.date :payment_date
      t.references :production, null: false, foreign_key: true

      t.timestamps
    end
  end
end
