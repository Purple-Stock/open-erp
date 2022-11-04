require 'rails_helper'

RSpec.describe Services::Sale::CountProductService, type: :services do


  context 'when call the service' do
    let(:product) { create(:product ) }
    let(:purchase_product) { create(:purchase_product, product_id: product.id) }

    it 'verify purchase count' do
      purchase_product
      result = Services::Sale::CountProductService.call(product.id, 'purchase_product')
      expect(purchase_product.quantity).to eq(result.to_i)
    end

    xit 'verify count sale product' do
    end

    xit 'verify balance product' do
    end
  end

end
