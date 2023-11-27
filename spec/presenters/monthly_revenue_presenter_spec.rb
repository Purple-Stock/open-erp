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
        FactoryBot.create_list(:bling_order_item, 4, store_id: BlingOrderItem::STORE_ID_NAME_KEY_VALUE['Shein'])
        FactoryBot.create_list(:bling_order_item, 3, store_id: BlingOrderItem::STORE_ID_NAME_KEY_VALUE['Shopee'])
      end

      it 'is an array of hash' do
        result = [{ label: 'Shein', month: 11, value: 40.0 }, { label: 'Shopee', month: 11, value: 30.0 }]
        bling_order_item_collection = BlingOrderItem.all
        expect(described_class.new(bling_order_item_collection).presentable).to eq(result)
      end
    end
  end
end
