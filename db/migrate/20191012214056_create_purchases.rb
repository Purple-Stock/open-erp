class CreatePurchases < ActiveRecord::Migration[6.0]
  def change
    create_table :purchases do |t|
      t.float :value
      t.references :supplier, foreign_key: true

      t.timestamps
    end
  end
end
