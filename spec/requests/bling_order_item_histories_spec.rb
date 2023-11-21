# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'BlingOrderItemHistories', type: :request do
  let(:user) { FactoryBot.create(:user) }

  before { sign_in user }

  describe 'GET /index' do
    it 'returns http success' do
      get bling_order_item_histories_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /day_quantity' do
    context 'when there is not data in collection' do
      it 'returns http success' do
        get day_quantities_bling_order_item_histories_path

        expect(response).to have_http_status(:success)
      end
    end

    context 'when there is data in collection' do
      before do
        FactoryBot.create_list(:bling_order_item, 2, store_id: BlingOrderItem::STORE_ID_NAME_KEY_VALUE['Shopee'],
                               account_id: user.account.id)
        FactoryBot.create_list(:bling_order_item, 2, date: Date.today - 2.days, account_id: user.account.id)
      end

      it 'returns http success' do
        get day_quantities_bling_order_item_histories_path

        expect(response).to have_http_status(:success)
      end
    end
  end
end
