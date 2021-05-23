class CreateSimploClients < ActiveRecord::Migration[6.0]
  def change
    create_table :simplo_clients do |t|
      t.string :name
      t.integer :age
      t.datetime :order_date

      t.timestamps
    end
  end
end
