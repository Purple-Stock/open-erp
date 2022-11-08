# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Product::UpdateStatus, type: :services do
  context 'when call the service' do
    let(:product) { create(:product) }

    it 'change status active true to active false' do
      result = described_class.call(product)
      expect(product.active).to eq(false)
    end

    it 'change status active false to active true' do
      product.active = false
      result = described_class.call(product)
      expect(product.active).to eq(true)
    end
  end
end
