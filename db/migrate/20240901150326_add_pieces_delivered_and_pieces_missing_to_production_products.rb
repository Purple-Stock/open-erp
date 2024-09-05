class AddPiecesDeliveredAndPiecesMissingToProductionProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :production_products, :pieces_delivered, :integer
    add_column :production_products, :pieces_missing, :integer
  end
end
