# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Product::CountQuantity, type: :services do
  before { allow_any_instance_of(Product).to receive(:create_stock).and_return(true) }

  context 'when call the service' do
    let(:product) { create(:product) }
    let(:purchase_product) { create(:purchase_product, product_id: product.id) }

    it 'verify purchase count' do
      purchase_product
      result = described_class.call(product: product, product_command: 'purchase_product')
      expect(purchase_product.quantity).to eq(result.to_i)
    end
  end
end
