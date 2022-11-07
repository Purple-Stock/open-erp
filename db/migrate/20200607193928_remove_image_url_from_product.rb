# frozen_string_literal: true

class RemoveImageUrlFromProduct < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :image_url, :varchar
  end
end
