class RemoveAllIntegerIds < ActiveRecord::Migration[7.0]
  def change
    remove_column :categories, :integer_id
    remove_column :customers, :integer_id
    remove_column :group_products, :integer_id
    remove_column :groups, :integer_id
    remove_column :post_data, :integer_id
    remove_column :products, :integer_id
    remove_column :purchase_products, :integer_id
    remove_column :purchases, :integer_id
    remove_column :sale_products, :integer_id
    remove_column :sales, :integer_id
    remove_column :simplo_clients, :integer_id
    remove_column :simplo_item_sales, :integer_id
    remove_column :simplo_items, :integer_id
    remove_column :simplo_order_payments, :integer_id
    remove_column :simplo_orders, :integer_id
    remove_column :simplo_products, :integer_id
    remove_column :suppliers, :integer_id
    remove_column :users, :integer_id
  end
end
