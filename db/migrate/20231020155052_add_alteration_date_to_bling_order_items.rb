class AddAlterationDateToBlingOrderItems < ActiveRecord::Migration[7.0]
  def change
    add_column :bling_order_items, :alteration_date, :datetime
  end
end
