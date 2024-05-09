# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductDecorator, type: :decorator do
  subject(:product_decorated) { product.decorate }

  let(:long_sku) { 'ADFSKJDFSKJHG-KJHLKJFHG-ASLKJFHJ-ASKJFHJ-AKLSJDFHAKSLJFH' }
  let(:truncated_sku) { 'ADFSKJDFSKJHG-KJ...' }
  let(:short_sku) { 'SHORTDESCRIPTION' }
  let(:product) { FactoryBot.create(:product, sku: long_sku) }

  describe '#sku' do
    context 'when short sku' do
      before { product.sku = short_sku }

      it 'returns the same sku' do
        expect(product_decorated.sku).to eq(short_sku)
      end
    end

    context 'when long sku' do
      it 'returns truncated version' do
        expect(product_decorated.sku).to eq(truncated_sku)
      end
    end

    context 'when nil sku' do
      before { product.sku = nil }

      it 'is also nil' do
        expect(product_decorated.sku).to be_nil
      end
    end
  end
end
