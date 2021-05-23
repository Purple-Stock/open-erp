class AddStoreEntranceToPurchaseProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :purchase_products, :store_entrance, :integer, default: 0
  end
end
