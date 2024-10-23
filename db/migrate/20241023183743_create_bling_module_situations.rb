class CreateBlingModuleSituations < ActiveRecord::Migration[7.0]
  def change
    create_table :bling_module_situations do |t|
      t.integer :situation_id, null: false
      t.string :name, null: false
      t.integer :inherited_id
      t.string :color
      t.integer :module_id, null: false

      t.timestamps
    end

    add_index :bling_module_situations, :situation_id, unique: true
  end
end
