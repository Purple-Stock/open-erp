class AddLostPiecesToProductionProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :production_products, :lost_pieces, :integer, default: 0
  end
end