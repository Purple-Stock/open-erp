class RemoveColumnsFromProduction < ActiveRecord::Migration[7.0]
  def change
    remove_column :productions, :delivery_date, :datetime
    remove_column :productions, :deliver_date, :datetime
    remove_column :productions, :pieces_delivered, :integer
  end
end
