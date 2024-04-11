# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyRevenueReport do
  describe '#initialize' do
    it 'raises argument error' do
      expect { described_class.new }.to raise_exception(ArgumentError)
    end
  end

  describe '#presentable' do
    context 'when there is not collection' do
      let(:datasets) do
        [{ x: '06/11/2023', shein: 0.0, shopee: 0.0, simple_7: 0.0, mercado_livre: 0.0, feira_madrugada: 0.0,
           nuvem_shop: 0.0, total: 0.0 }]
      end

      before { allow(Date).to receive(:today).and_return Date.new(2023, 11, 6) }

      it 'is empty' do
        blank_collection = BlingOrderItem.all
        expect(described_class.new(blank_collection).presentable).to eq(datasets)
      end
    end

    context 'when there is data in the collection with nil in value' do
      let(:datasets) do
        [{ x: '06/11/2023', shein: 0.0, shopee: 0.0, simple_7: 0.0, mercado_livre: 0.0, feira_madrugada: 0.0,
           nuvem_shop: 0.0, total: 0.0 }]
      end

      before do
        allow(Date).to receive(:today).and_return Date.new(2023, 11, 6)
        FactoryBot.create_list(:bling_order_item, 4, store_id: '204219105', value: nil)
        FactoryBot.create_list(:bling_order_item, 3, store_id: '204219105', value: nil, date: Date.new(2023, 10, 3))
      end

      it 'is an array of hash' do
        bling_order_item_collection = BlingOrderItem.all
        expect(described_class.new(bling_order_item_collection).presentable).to eq(datasets)
      end
    end

    context 'when there is data in the collection for both Shein and Shopee' do
      let(:datasets) do
        [{ x: '06/11/2023', shein: 8.0, shopee: 6.0, simple_7: 0.0, mercado_livre: 0.0, feira_madrugada: 0.0,
           nuvem_shop: 0.0, total: 14.0 }]
      end

      before do
        allow(Date).to receive(:today).and_return Date.new(2023, 11, 6)
        FactoryBot.create_list(:bling_order_item, 4, store_id: '204219105')
        FactoryBot.create_list(:bling_order_item, 3, store_id: '203737982')
      end

      it 'is an array of hash' do
        expect(described_class.new(BlingOrderItem.all).presentable).to eq(datasets)
      end
    end

    context 'when filter by today and yesterday' do
      let(:filter) { { initial_date: '2023-11-5', final_date: '2023-11-6' } }
      let(:datasets) do
        [{ x: '05/11/2023 - 06/11/2023', shein: 12.0, shopee: 6.0, simple_7: 0.0, mercado_livre: 0.0,
           feira_madrugada: 0.0, nuvem_shop: 0.0, total: 18.0 }]
      end

      before do
        allow(Date).to receive(:today).and_return Date.new(2023, 11, 6)
        FactoryBot.create_list(:bling_order_item, 4, store_id: '204219105')
        FactoryBot.create_list(:bling_order_item, 2, store_id: '204219105', date: Date.new(2023, 11, 5))
        FactoryBot.create_list(:bling_order_item, 3, store_id: '203737982')
      end

      it 'has two axis x with today and yesterday value' do
        expect(described_class.new(BlingOrderItem.all, filter).presentable).to eq(datasets)
      end
    end
  end
end
