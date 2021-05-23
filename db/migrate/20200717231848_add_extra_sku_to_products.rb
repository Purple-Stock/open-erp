class AddExtraSkuToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :extra_sku, :string
  end
end
