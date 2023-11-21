class AddAccountIdToBlingOrderItem < ActiveRecord::Migration[7.0]
  def change
    add_reference :bling_order_items, :account, foreign_key: false
  end
end
