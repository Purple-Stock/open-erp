# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Stocks', type: :request do
  include_context 'with user signed in'

  describe 'GET /index' do
    before do
      FactoryBot.create_list(:bling_order_item, 2, account_id: user.account.id)
    end

    context 'when there is no filter' do
      before { get bling_order_items_path }

      it 'is success' do
        expect(response).to be_successful
      end
    end
  end

  describe 'GET /show' do
    let(:bling_order_item) { FactoryBot.create(:bling_order_item) }

    before do
      get bling_order_item_path(bling_order_item)
    end

    it 'is success' do
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    let(:bling_order_item) { FactoryBot.create(:bling_order_item) }

    before do
      get edit_bling_order_item_path(bling_order_item)
    end

    it 'is success' do
      expect(response).to be_successful
    end
  end

  describe 'GET /update' do
    let(:bling_order_item) { FactoryBot.create(:bling_order_item) }
    let(:situation_id) { '99' }


    context 'when permitted attribute' do
      before do
        patch bling_order_item_path(bling_order_item), params: { bling_order_item: { situation_id: } }
      end

      it 'is found' do
        expect(response).to have_http_status(:found)
      end

      it 'is 99' do
        expect(bling_order_item.reload.situation_id).to eq(situation_id)
      end
    end

    context 'when not permitted attribute' do
      let(:alteration_date) { '2024-1-1' }

      before do
        patch bling_order_item_path(bling_order_item), params: { bling_order_item: { alteration_date: } }
      end

      it 'is found' do
        expect(response).to have_http_status(:found)
      end

      it 'does not change alteration date' do
        expect(bling_order_item.reload.alteration_date.to_date).not_to eq(alteration_date.to_date)
      end
    end
  end

  describe 'DELETE /destroy' do
    let(:bling_order_item) { FactoryBot.create(:bling_order_item) }

    context 'when not found at bling' do
      before do
        delete bling_order_item_path(bling_order_item)
      end

      it 'is found' do
        expect(response).to have_http_status(:found)
      end

      it 'changes status to deleted at bling' do
        expect(bling_order_item.reload.situation_id).to eq('0')
      end
    end

    context 'when it is found at bling' do
      before do
        delete bling_order_item_path(bling_order_item)
      end

      it 'is found' do
        expect(response).to have_http_status(:found)
      end

      it 'does not change status to deleted at bling' do
        expect(bling_order_item.reload.situation_id).not_to eq('0')
      end
    end
  end
end
