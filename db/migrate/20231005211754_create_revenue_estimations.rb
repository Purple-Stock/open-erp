class CreateRevenueEstimations < ActiveRecord::Migration[7.0]
  def change
    create_table :revenue_estimations do |t|
      t.decimal :average_ticket
      t.integer :quantity
      t.decimal :revenue
      t.date :date

      t.timestamps
    end
  end
end
