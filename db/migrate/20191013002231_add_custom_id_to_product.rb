class AddCustomIdToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :custom_id, :string
  end
end
