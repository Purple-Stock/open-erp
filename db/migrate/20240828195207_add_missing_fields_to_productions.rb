class AddMissingFieldsToProductions < ActiveRecord::Migration[7.0]
  def change
    change_table :productions, bulk: true do |t|
      t.column :number, :integer, if_not_exists: true
      t.column :delivery_date, :date, if_not_exists: true
      t.column :pieces_delivered, :integer, if_not_exists: true
      t.column :pieces_missing, :integer, if_not_exists: true
      t.column :expected_delivery_date, :date, if_not_exists: true
      t.column :confirmed, :boolean, if_not_exists: true
      t.column :paid, :boolean, if_not_exists: true
      t.column :observation, :text, if_not_exists: true
      
      # Add indexes
      t.index :number, if_not_exists: true
      t.index :cut_date, if_not_exists: true
      t.index :delivery_date, if_not_exists: true
      t.index :expected_delivery_date, if_not_exists: true
    end

    # Add foreign key for account if it doesn't exist
    unless foreign_key_exists?(:productions, :accounts)
      add_foreign_key :productions, :accounts
    end

    # Add foreign key for tailor if it doesn't exist
    unless foreign_key_exists?(:productions, :tailors)
      add_foreign_key :productions, :tailors
    end
  end
end