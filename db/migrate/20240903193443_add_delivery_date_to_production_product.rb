class AddDeliveryDateToProductionProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :production_products, :delivery_date, :date
  end
end
