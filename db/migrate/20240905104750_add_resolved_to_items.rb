class AddResolvedToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :resolved, :boolean, default: false
    add_index :items, :resolved
  end
end
