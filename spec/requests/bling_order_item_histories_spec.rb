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

  describe 'GET /monthly_revenue' do
    context 'when there is not data in collection' do
      it 'returns http success' do
        get daily_revenue_bling_order_item_histories_path

        expect(response).to have_http_status(:success)
      end
    end

    context 'when there is data in collection' do
      let(:date) { Date.today }
      let(:datasets) do
        [{ 'mercado_livre' => 0.0, 'shein' => 4.0, 'shopee' => 0.0, 'simple_7' => 0.0, 'x' => date.strftime('%d/%m/%Y') }]
      end

      before do
        FactoryBot.create_list(:bling_order_item, 2, store_id: '204219105',
                                                     account_id: user.account.id)
      end

      it 'matches array of datasets' do
        get daily_revenue_bling_order_item_histories_path

        result = JSON.parse(response.body)

        expect(result).to match_array(datasets)
      end
    end
  end
end
