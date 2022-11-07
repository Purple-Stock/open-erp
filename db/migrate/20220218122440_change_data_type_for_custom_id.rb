# frozen_string_literal: true

class ChangeDataTypeForCustomId < ActiveRecord::Migration[6.0]
  def change
    change_column :products, :custom_id, 'integer USING CAST(custom_id AS integer)'
  end
end
