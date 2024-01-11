# frozen_string_literal: true

require 'rails_helper'
require 'forecasts/basic_stock'

RSpec.describe ::Forecasts::BasicStock do
  include_context 'when user account'
  let(:sku) { 'VEST' }
  let(:product) { FactoryBot.create(:product, sku: sku, account_id: user.account.id) }
  let(:order) { FactoryBot.create(:bling_order_item, date: Date.new(2024, 1, 1), account: user.account) }
  let(:stock) { FactoryBot.create(:stock, total_balance: 0, account_id: user.account.id, product: product) }

  before do
    allow(Date).to receive(:today).and_return Date.new(2024, 1, 9)
    FactoryBot.create(:item, sku: sku, quantity: 2, bling_order_item: order, product_id: product.id, account: user.account)
  end

  describe '#count_sold' do
    subject(:count_sold) { described_class.new(stock).count_sold }

    it 'counts 2' do
      expect(count_sold).to eq(2)
    end
  end

  describe '#calculate' do
    subject(:calculate) { described_class.new(stock).calculate }


    context 'when there is no order related to stock' do
      before { order.destroy }

      context 'when the total balance is positive' do
        it 'calculates 0' do
          expect(calculate).to eq(0)
        end
      end

      context 'when the total balance is negative' do
        before { stock.update(total_balance: -2) }

        it 'calculates 2' do
          expect(calculate).to eq(2)
        end
      end

      context 'when the total balance is zero' do
        before { stock.update(total_balance: 0) }

        it 'calculates 0' do
          expect(calculate).to eq(0)
        end
      end
    end

    context 'when total_balance is zero' do
      it 'calculates 2' do
        expect(calculate).to eq(2)
      end
    end

    context 'when total_balance is negative -2' do
      before { stock.update(total_balance: -2) }

      it 'calculates 4' do
        expect(calculate).to eq(4)
      end
    end

    context 'when total_balance is equal items sold quantity (2)' do
      before { stock.update(total_balance: 2) }

      it 'calculates 0' do
        expect(calculate).to eq(0)
      end
    end

    context 'when total_balance is too much superior (1000) to order items sold' do
      before { stock.update(total_balance: 1_000) }

      it 'calculates 0' do
        expect(calculate).to eq(0)
      end
    end
  end
end
