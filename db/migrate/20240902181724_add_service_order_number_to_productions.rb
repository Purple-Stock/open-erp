class AddServiceOrderNumberToProductions < ActiveRecord::Migration[7.0]
  def change
    add_column :productions, :service_order_number, :string
  end
end
