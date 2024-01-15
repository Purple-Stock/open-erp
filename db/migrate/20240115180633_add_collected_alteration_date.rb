class AddCollectedAlterationDate < ActiveRecord::Migration[7.0]
  def change
    add_column :bling_order_items, :collected_alteration_date, :date
  end
end
