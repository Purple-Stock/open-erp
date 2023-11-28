# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MonthlyRevenuePresenter do
  let(:november_shein_values) do
    { label: 'Shein',
      data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 8.0, 0.0] }
  end
  let(:august_shopee_values) do
    { label: 'Shopee',
      data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.0, 0.0, 0.0] }
  end
  let(:zero_simple_7_values) do
    { label: 'Simple 7',
      data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] }
  end
  let(:zero_mercado_livre_values) do
    { label: 'Mercado Livre',
      data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] }
  end
  let(:zeros_datasets) do
    [{ label: 'Shein',
       data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] },
     { label: 'Shopee',
       data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] },
     { label: 'Simple 7',
       data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] },
     { label: 'Mercado Livre',
       data: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] }]
  end

  describe '#initialize' do
    it 'raises argument error' do
      expect { described_class.new }.to raise_exception(ArgumentError)
    end
  end

  describe '#presentable' do
    context 'when there is not collection' do
      it 'is empty' do
        blank_collection = BlingOrderItem.all
        expect(described_class.new(blank_collection).presentable).to eq(zeros_datasets)
      end
    end

    context 'when there is data in the collection with nil in value' do
      before do
        allow(Date).to receive(:today).and_return Date.new(2023, 11, 6)
        FactoryBot.create_list(:bling_order_item, 4, store_id: '204219105', value: nil)
        FactoryBot.create_list(:bling_order_item, 3, store_id: '204219105', value: nil, date: Date.new(2023, 10, 3))
      end

      it 'is an array of hash' do
        bling_order_item_collection = BlingOrderItem.all
        expect(described_class.new(bling_order_item_collection).presentable).to eq(zeros_datasets)
      end
    end

    context 'when there is data in the collection for both Shein and Shopee' do
      before do
        allow(Date).to receive(:today).and_return Date.new(2023, 11, 6)
        FactoryBot.create_list(:bling_order_item, 4, store_id: '204219105')
        FactoryBot.create_list(:bling_order_item, 3, store_id: '203737982', date: Date.new(2023, 10, 3))
      end

      it 'is an array of hash' do
        datasets = [november_shein_values, august_shopee_values, zero_simple_7_values, zero_mercado_livre_values]
        expect(described_class.new(BlingOrderItem.all).presentable).to eq(datasets)
      end
    end
  end
end
