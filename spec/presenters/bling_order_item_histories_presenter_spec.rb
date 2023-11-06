# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlingOrderItemHistoriesPresenter do
  describe '#initialize' do
    it 'is truthy' do
      expect(described_class.new).to be_truthy
    end
  end

  describe '#presentable' do
    context 'when there is not collection' do
      it 'is empty' do
        expect(described_class.new.bling_order_item_collection).to be_empty
      end
    end
  end
end
