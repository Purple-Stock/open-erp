# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Bling::Order, type: :services do
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
        result = described_class.call(order_command: order_command, tenant: 1, situation: situation, options: options)
        expect(result['data'].dig(0).fetch('data')).to eq('2022-12-31')
      end

      it 'counts by 1' do
        result = described_class.call(order_command: order_command, tenant: 1, situation: situation, options: options)
        expect(result['data'].count).to eq(1)
      end
    end
  end
end
