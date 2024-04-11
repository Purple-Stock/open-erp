class AddFeatureKeyToFeatures < ActiveRecord::Migration[7.0]
  def change
    add_column :features, :feature_key, :integer, null: false, default: 0
  end
end
