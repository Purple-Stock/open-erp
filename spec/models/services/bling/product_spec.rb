# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Bling::Product, type: :services do
  let(:product_command) { 'find_products' }

  describe '#call' do
    before { FactoryBot.create(:bling_datum, account_id: 1) }

    context 'when given number of page in options' do
      before { allow(Rails).to receive(:env).and_return('no_test') }

      let(:options) { { max_pages: 1 } }

      it 'counts 100 data' do
        VCR.use_cassette('bling_product_max_pages', erb: true) do
          result = described_class.call(product_command:, tenant: 1, options:)
          expect(result['data'].count).to eq(100)
        end
      end
    end

    context 'when filtering by initial' do
      let(:options) { { dataInclusaoInicial: '2022-12-20' } }

      before { allow(Rails).to receive(:env).and_return('no_test') }

      it 'counts by 1207' do
        VCR.use_cassette('bling_product_by_initial_date', erb: true) do
          result = described_class.call(product_command:, tenant: 1, options:)
          expect(result['data'].length).to eq(1207)
        end
      end
    end
  end
end
