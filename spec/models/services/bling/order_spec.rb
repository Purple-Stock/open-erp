# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Bling::Order, type: :services do
  BlingDatum.destroy_all
  let!(:bling_datum) { FactoryBot.create(:bling_datum, account_id: 1) }
  let(:order_command) { 'find_orders' }
  let(:situation) { 15 }

  describe '#initialize' do
    it 'is truthy' do
      expect(described_class.call(order_command: order_command, tenant: 1, situation: situation)).to be_truthy
    end
  end

  describe '#call' do
    context 'when filtering by initial and final dates' do
      let(:situation) { 9 }
      let(:options) { { dataInicial: '2022-12-31', dataFinal: '2022-12-31' } }

      it 'is has data equal initial date' do
        VCR.use_cassette('bling_order_current_day', erb: true) do
          result = described_class.call(order_command: order_command, tenant: 1, situation: situation, options: options)
          expect(result['data'][0].fetch('data')).to eq('2022-12-31')
        end
      end

      it 'counts by 1' do
        VCR.use_cassette('bling_order_current_day', erb: true) do
          result = described_class.call(order_command: order_command, tenant: 1, situation: situation, options: options)
          expect(result['data'].count).to eq(1)
        end
      end
    end

    context 'when options have array of situations' do
      context 'when situation is 15' do
        let(:options) { { idsSituacoes: [15] } }

        it 'is has situation id equal situation in options' do
          VCR.use_cassette('bling_order_situation', erb: true) do
            result = described_class.call(order_command: order_command, tenant: 1, situation:, options: options)
            expect(result['data'][0]['situacao']['id']).to eq(options[:idsSituacoes].first)
          end
        end
      end

      context 'when situation is 9' do
        let(:options) { { idsSituacoes: [9] } }

        it 'is has situation id equal situation in options' do
          VCR.use_cassette('bling_order_situation_9', erb: true) do
            result = described_class.call(order_command: order_command, tenant: 1, situation:, options: options)
            expect(result['data'][0]['situacao']['id']).to eq(options[:idsSituacoes].first)
          end
        end
      end
    end
  end
end
