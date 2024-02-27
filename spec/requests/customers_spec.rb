# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Customers', type: :request do
  describe 'GET /customers' do
    include_context 'with user signed in'
    context 'when feature bling' do
      include_context 'with bling feature'

      it 'has successfully response' do
        get customers_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'without bling feature' do
      it 'redirects to products list' do
        get customers_path

        expect(response).to redirect_to(products_path)
      end
    end
  end

  describe 'GET /customers/new' do
    include_context 'with user signed in'
    context 'when feature bling' do
      include_context 'with bling feature' do
        it 'has successfully response' do
          get new_customer_path

          expect(response).to have_http_status(:success)
        end
      end
    end

    context 'without feature bling as a stock manager only' do
      it 'redirects to products list' do
        get new_customer_path

        expect(response).to redirect_to(products_path)
      end
    end
  end
end
