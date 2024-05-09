class AddBlingIdToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :bling_id, :bigint
  end
end
