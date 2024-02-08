class AddOriginalSituationIdToBlingOrderItem < ActiveRecord::Migration[7.0]
  def change
    add_column :bling_order_items, :original_situation_id, :string
  end
end
