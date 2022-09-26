# == Schema Information
#
# Table name: group_products
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer
#  product_id :integer
#
# Indexes
#
#  index_group_products_on_group_id    (group_id)
#  index_group_products_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (product_id => products.id)
#
class GroupProduct < ApplicationRecord
  belongs_to :product
  belongs_to :group
end
