class CreateFinanceData < ActiveRecord::Migration[7.0]
  def change
    create_table :finance_data do |t|
      t.date :date
      t.decimal :income
      t.decimal :expense
      t.decimal :fixed_amount

      t.timestamps
    end
  end
end
