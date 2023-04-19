# frozen_string_literal: true

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
#  product_id     :bigint
#  purchase_id    :bigint
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
require 'rails_helper'

RSpec.describe PurchaseProduct, type: :model do
  it { is_expected.to belong_to(:product) }

  context 'when create' do
    let(:purchase_product) { create(:purchase_product) }

    it 'is valid' do
      expect(purchase_product).to be_valid
    end

    it 'is not should be valid' do
      purchase_product.product_id = nil
      expect(purchase_product).not_to be_valid
    end
  end
end
