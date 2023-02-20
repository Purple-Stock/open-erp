# frozen_string_literal: true

# == Schema Information
#
# Table name: simplo_items
#
#  id              :bigint           not null, primary key
#  quantity        :integer
#  sku             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  product_id      :integer
#  simplo_order_id :integer
#
# Indexes
#
#  index_simplo_items_on_product_id       (product_id)
#  index_simplo_items_on_simplo_order_id  (simplo_order_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (simplo_order_id => simplo_orders.id)
#
class SimploItem < ApplicationRecord
  belongs_to :simplo_order
  belongs_to :product, optional: true
end
