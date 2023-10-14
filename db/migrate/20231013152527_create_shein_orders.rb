class CreateSheinOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :shein_orders do |t|
      t.json :data

      t.timestamps
    end
  end
end
