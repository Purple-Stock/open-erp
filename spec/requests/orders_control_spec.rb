require 'rails_helper'

RSpec.describe 'orders control' do
  context 'when show orders control' do
    before do
      get show_orders_control_path
    end

    it 'is a successful response' do
      expect(response).to have_http_status(:found)
    end
  end

  context 'when show orders products stock' do
    before do
      get show_orders_products_stock_path
    end

    it 'is a successful response' do
      expect(response).to have_http_status(:found)
    end
  end

  context 'when show orders business day' do
    before do
      get show_orders_business_day_path
    end

    it 'is a successful response' do
      expect(response).to have_http_status(:found)
    end
  end
end
