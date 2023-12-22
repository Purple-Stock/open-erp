# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Product::Duplicate, type: :services do
  before { allow_any_instance_of(Product).to receive(:create_stock).and_return(true) }

  context 'when call the service' do
    let(:product) { create(:product) }

    it 'change for copy name' do
      result = described_class.call(product: product)
      expect(Product.last.sku).to eq(product.sku)
      expect(Product.last.name).to eq("#{product.name} Cópia")
    end
  end
end
