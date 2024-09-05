class RemoveNumberFromProductions < ActiveRecord::Migration[7.0]
  def change
    remove_column :productions, :number, :integer
  end
end
