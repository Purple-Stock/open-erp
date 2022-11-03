require 'rails_helper'

RSpec.describe PurchaseProduct, type: :model do
  it { should belong_to(:product) }

  context 'when create' do
    let(:purchase_product) { create(:purchase_product) }

    it 'should be valid' do
      expect(purchase_product).to be_valid
    end

    it 'is not should be valid' do
      purchase_product.product_id = nil
      expect(purchase_product).to_not be_valid
    end

  end
end