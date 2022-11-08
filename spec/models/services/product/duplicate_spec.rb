# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Product::Duplicate, type: :services do
  context 'when call the service' do
    let(:product) { create(:product) }

    it 'change for copy name' do
      result = described_class.call(product)
      expect(Product.last.name).to eq("#{product.name} Cópia")
    end
  end
end
