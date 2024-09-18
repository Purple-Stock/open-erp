class AddPaymentDateToProductions < ActiveRecord::Migration[7.0]
  def change
    add_column :productions, :payment_date, :date
  end
end
