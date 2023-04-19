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
    xit { is_expected.to belong_to(:sale) }
    it { is_expected.to belong_to(:product) }
  end

  describe 'scopes' do
    let(:sale) { create(:sale) }
    let(:sale_product) { create(:sale_product, sale: sale) }
    let(:sale_product2) { create(:sale_product, sale: sale) }
    let(:sale_product3) { create(:sale_product, sale: sale) }

    xit 'should return all sale products from a sale' do
      expect(SaleProduct.from_sale_store(sale.store_sale)).to include(sale_product)
      expect(SaleProduct.from_sale_store(sale.store_sale)).to include(sale_product2)
      expect(SaleProduct.from_sale_store(sale.store_sale)).to include(sale_product3)
    end
  end

  describe 'validations' do
    xit { is_expected.to validate_presence_of(:quantity) }
    xit { is_expected.to validate_presence_of(:value) }
  end

  describe 'delegations' do
    xit { is_expected.to delegate_method(:name).to(:product).with_prefix }
  end

  describe 'callbacks' do
    xit { is_expected.to callback(:update_product).after(:save) }
  end
end
