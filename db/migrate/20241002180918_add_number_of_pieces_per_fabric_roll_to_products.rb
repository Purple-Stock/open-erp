class AddNumberOfPiecesPerFabricRollToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :number_of_pieces_per_fabric_roll, :integer
  end
end
