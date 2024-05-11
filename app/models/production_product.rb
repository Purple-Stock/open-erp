# == Schema Information
#
# Table name: production_products
#
#  id            :bigint           not null, primary key
#  quantity      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  product_id    :bigint           not null
#  production_id :bigint           not null
#
# Indexes
#
#  index_production_products_on_product_id     (product_id)
#  index_production_products_on_production_id  (production_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (production_id => productions.id)
#
class ProductionProduct < ApplicationRecord
  belongs_to :product
  belongs_to :production

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
