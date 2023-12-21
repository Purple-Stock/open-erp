# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Bling::Stock, type: :services do
  let(:stock_command) { 'find_stocks' }

  describe '#call' do
    before { FactoryBot.create(:bling_datum, account_id: 1) }

    context 'when filtering by bling_product_id' do
      let(:options) { { idsProdutos: [16_181_499_539, 16_181_499_538] } }

      it 'counts by 2' do
        VCR.use_cassette('bling_stock_by_product_id', erb: true) do
          result = described_class.call(stock_command:, tenant: 1, options:)
          expect(result['data'].length).to eq(2)
        end
      end
    end

    context 'when filtering by bling_product_id absent in bling' do
      let(:options) { { idsProdutos: [99, 98] } }

      it 'counts by 0' do
        VCR.use_cassette('bling_stock_by_product_id_absent', erb: true) do
          result = described_class.call(stock_command:, tenant: 1, options:)
          expect(result['data'].length).to eq(0)
        end
      end
    end

    context 'when filtering by bling_product_id present and absent in bling' do
      let(:options) { { idsProdutos: [16_181_499_539, 98] } }

      it 'counts by 1' do
        VCR.use_cassette('bling_stock_by_product_id_present_absent', erb: true) do
          result = described_class.call(stock_command:, tenant: 1, options:)
          expect(result['data'].length).to eq(1)
        end
      end
    end
  end
end
