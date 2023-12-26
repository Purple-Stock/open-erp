class AddConsiderToProductions < ActiveRecord::Migration[7.0]
  def change
    add_column :productions, :consider, :boolean, default: false
  end
end
