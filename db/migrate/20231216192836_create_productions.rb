class CreateProductions < ActiveRecord::Migration[7.0]
  def change
    create_table :productions do |t|
      t.datetime :cut_date
      t.datetime :deliver_date

      t.timestamps
    end
  end
end
