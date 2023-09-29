# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Bling::Order, type: :services do
  let(:account_id) { 1 }
  let!(:bling_datum) { FactoryBot.create(:bling_datum, account_id: account_id) }
  let(:order_command) { 'find_orders' }
  let(:situation) { 15 }

  describe '#initialize' do
    it 'is truthy' do
      expect(described_class.call(order_command: order_command, tenant: account_id, situation: situation)).to be_truthy
    end
  end

  describe '#call' do
    context 'when filtering by initial and final dates' do
      let(:situation) { 9 }
      let(:initial_date) { '2022-12-31' }
      let(:end_date) { '2022-12-31' }
      let(:options) { { dataInicial: initial_date, dataFinal: end_date } }

      it 'is has data equal initial date' do
        result = described_class.call(order_command: order_command, tenant: account_id, situation: situation, options: options)
        expect(result['data'].dig(0).fetch('data')).to eq(initial_date)
      end

      it 'counts by 1' do
        result = described_class.call(order_command: order_command, tenant: account_id, situation: situation, options: options)
        expect(result['data'].count).to eq(1)
      end
    end
  end
end
