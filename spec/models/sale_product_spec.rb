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
#  product_id :bigint
#  sale_id    :bigint
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
require 'rails_helper'

# Define the test suite
RSpec.describe SaleProduct do
  describe 'associations' do
    it { is_expected.to belong_to(:product) }
  end

  describe 'validations' do
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than(0) }
  end
end
