class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :company_name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
