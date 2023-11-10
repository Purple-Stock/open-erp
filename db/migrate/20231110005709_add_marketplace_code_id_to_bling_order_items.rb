class AddMarketplaceCodeIdToBlingOrderItems < ActiveRecord::Migration[7.0]
  def change
    add_column :bling_order_items, :marketplace_code_id, :string
  end
end
