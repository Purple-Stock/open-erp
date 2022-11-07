# frozen_string_literal: true

class AddMonthsToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :months, :integer, default: 1
  end
end
