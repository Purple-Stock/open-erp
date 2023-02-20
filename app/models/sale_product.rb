# frozen_string_literal: true

# == Schema Information
#
# Table name: sale_products
#
#  id         :bigint           not null, primary key
#  quantity   :integer
#  value      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#  product_id :integer
#  sale_id    :integer
#
# Indexes
#
#  index_sale_products_on_account_id  (account_id)
#  index_sale_products_on_product_id  (product_id)
#  index_sale_products_on_sale_id     (sale_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (sale_id => sales.id)
#
class SaleProduct < ApplicationRecord
  belongs_to :sale, optional: true
  belongs_to :product
  acts_as_tenant :account
  scope :from_sale_store, ->(store = 'SemLoja') { includes(:sale).where(sales: { store_sale: store }) }
end
