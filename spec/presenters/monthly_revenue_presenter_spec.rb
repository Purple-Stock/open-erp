# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MonthlyRevenuePresenter do
  describe '#initialize' do
    it 'raises argument error' do
      expect { described_class.new }.to raise_exception(ArgumentError)
    end
  end

  describe '#presentable' do
    context 'when there is not collection' do
      it 'is empty' do
        empty_bling_order_item_collection = BlingOrderItem.all
        expect(described_class.new(empty_bling_order_item_collection).presentable).to be_empty
      end
    end

    context 'when there is data in the collection' do
      before do
        allow(Date).to receive(:today).and_return Date.new(2023, 11, 6)
        FactoryBot.create_list(:bling_order_item, 4, store_id: '204219105')
        FactoryBot.create_list(:bling_order_item, 3, store_id: '204219105', date: Date.new(2023, 10, 3))
      end

      it 'is an array of hash' do
        result = [{ label: 'Shein',
                    data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 8.0, 0.0] }]
        bling_order_item_collection = BlingOrderItem.all
        expect(described_class.new(bling_order_item_collection).presentable).to eq(result)
      end
    end

    context 'when there is data in the collection with nil in value' do
      before do
        allow(Date).to receive(:today).and_return Date.new(2023, 11, 6)
        FactoryBot.create_list(:bling_order_item, 4, store_id: '204219105', value: nil)
        FactoryBot.create_list(:bling_order_item, 3, store_id: '204219105', value: nil, date: Date.new(2023, 10, 3))
      end

      it 'is an array of hash' do
        result = [{ label: 'Shein',
                    data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] }]
        bling_order_item_collection = BlingOrderItem.all
        expect(described_class.new(bling_order_item_collection).presentable).to eq(result)
      end
    end

    context 'when there is data in the collection for both Shein and Shopee' do
      before do
        allow(Date).to receive(:today).and_return Date.new(2023, 11, 6)
        FactoryBot.create_list(:bling_order_item, 4, store_id: '204219105')
        FactoryBot.create_list(:bling_order_item, 3, store_id: '203737982', date: Date.new(2023, 10, 3))
      end

      it 'is an array of hash' do
        result = [{ label: 'Shein',
                    data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 8.0, 0.0] },
                  label: 'Shopee',
                  data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 0.0, 0.0]]
        expect(described_class.new(BlingOrderItem.all).presentable).to eq(result)
      end
    end
  end
end
