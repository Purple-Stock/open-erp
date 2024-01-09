# frozen_string_literal: true

require 'rails_helper'
require 'forecasts/basic_stock'

RSpec.describe ::Forecasts::BasicStock do
  describe '#calculate' do
    subject(:calculate) { described_class.new(stock).calculate }

    include_context 'when user account'
    let(:sku) { 'VEST' }
    let(:product) { FactoryBot.create(:product, sku: sku, account_id: user.account.id) }
    let(:order) { FactoryBot.create(:bling_order_item, date: Date.new(2024, 1, 1), account: user.account) }
    let(:stock) { FactoryBot.create(:stock, total_balance: 0, account_id: user.account.id, product: product) }

    before do
      allow(Date).to receive(:today).and_return Date.new(2024, 1, 9)
      FactoryBot.create(:item, sku: sku, quantity: 2, bling_order_item: order, product_id: product.id, account: user.account)
    end

    context 'when total_balance is zero' do
      it 'calculates 2' do
        expect(calculate).to eq(2)
      end
    end
  end
end
