# == Schema Information
#
# Table name: purchase_products
#
#  id             :bigint           not null, primary key
#  quantity       :integer
#  store_entrance :integer          default("Sem_Loja")
#  value          :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  account_id     :integer
#  product_id     :integer
#  purchase_id    :integer
#
# Indexes
#
#  index_purchase_products_on_account_id   (account_id)
#  index_purchase_products_on_product_id   (product_id)
#  index_purchase_products_on_purchase_id  (purchase_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (purchase_id => purchases.id)
#
class PurchaseProduct < ApplicationRecord
  belongs_to :purchase, optional: true
  belongs_to :product
  acts_as_tenant :account
  enum store_entrance: %i[Sem_Loja LojaPrincipal LojaSecundaria]
  scope :from_store, lambda { |store = store_entrances['Sem_Loja']|
                       where('store_entrance = ?', store_entrances[store])
                     }

  DATATABLE_COLUMNS = %w[custom_id name].freeze

  class << self
    def filter_products(purchased_products, search_value)
      return all if search_value.blank?

      result = none
      DATATABLE_COLUMNS.each do |column|
        filter = purchased_products.where("products.#{column} ILIKE ? ", "%#{search_value}%")
        result = result.or(filter)
      end
      result
    end

    def datatable_order(order_column_index, order_dir)
      order_column_index = 1 if order_column_index == 4
      order("products.#{PurchaseProduct::DATATABLE_COLUMNS[order_column_index]} #{order_dir}")
    end

    def inventory_quantity(custom_id, quantity, store)
      product = Product.find_by(custom_id: custom_id)
      purchase_product = product.purchase_products.from_store(store).sum('Quantity')
      sale_products = product.sale_products.from_sale_store(store).sum('Quantity')
      balance = purchase_product - sale_products
      purchase_quantity = quantity - balance
      purchase_store = 1
      purchase_store = 2 if store == 'PurchaseStoreSP'
      begin
        PurchaseProduct.create(product_id: product.id, quantity: purchase_quantity, store_entrance: purchase_store)
      rescue ArgumentError
        puts 'erro'
      end
    end
  end
end
