class AddTailorIdToProductions < ActiveRecord::Migration[7.0]
  def change
    add_reference :productions, :tailor, null: true, foreign_key: true
  end
end
