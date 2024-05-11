class CreateTailors < ActiveRecord::Migration[7.0]
  def change
    create_table :tailors do |t|
      t.string :name

      t.timestamps
    end
  end
end
