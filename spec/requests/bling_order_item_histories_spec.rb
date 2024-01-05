# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'BlingOrderItemHistories', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:params) do
    { bling_order: { initial_date: (Date.today - 1.day).strftime,
                     final_date: Date.today.strftime } }
  end

  before do
    allow_any_instance_of(BlingOrderItem).to receive(:synchronize_items).and_return(true)
    sign_in user
  end

  describe 'GET /index' do
    before do
      allow(Date).to receive(:today).and_return Date.new(2023, 11, 9)
      FactoryBot.create_list(:bling_order_item, 2, store_id: '204219105',
                             account_id: user.account.id)
    end

    context 'when not filtering by date range' do
      it 'returns http success' do
        get bling_order_item_histories_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'when filtering by date range' do
      it 'returns http success' do
        get bling_order_item_histories_path(params)
        expect(response).to have_http_status(:success)
      end
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
