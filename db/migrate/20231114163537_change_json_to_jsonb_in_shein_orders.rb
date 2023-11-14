class ChangeJsonToJsonbInSheinOrders < ActiveRecord::Migration[7.0]
  def up
    # Change the column type from JSON to JSONB
    change_column :shein_orders, :data, :jsonb
  end

  def down
    # Revert the column type from JSONB to JSON
    change_column :shein_orders, :data, :json
  end
end
