class AddStorerefToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :store_id, :integer
  end
end
