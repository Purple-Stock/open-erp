class CreateAccountFeatures < ActiveRecord::Migration[7.0]
  def change
    create_table :account_features do |t|
      t.bigint :account_id, null: false, unique: true
      t.integer :feature_id, null: false, unique: true
      t.boolean :is_enabled, default: false

      t.timestamps
    end
  end
end
