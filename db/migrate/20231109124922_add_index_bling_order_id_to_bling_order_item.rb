# frozen_string_literal: true

# To deal with upinsert_all unique_by: :column_name options
# To not raise exception "upsert no unique index found"
# Check https://github.com/jesjos/active_record_upsert/issues/101
# And https://stackoverflow.com/questions/59472362/rails-upsert-no-unique-index-found
# discussions.
class AddIndexBlingOrderIdToBlingOrderItem < ActiveRecord::Migration[7.0]
  def change
    add_index :bling_order_items, :bling_order_id, unique: :true
  end
end
