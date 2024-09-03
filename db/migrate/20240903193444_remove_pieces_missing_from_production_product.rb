class RemovePiecesMissingFromProductionProduct < ActiveRecord::Migration[7.0]
  def change
    remove_column :production_products, :pieces_missing, :integer
  end
end
