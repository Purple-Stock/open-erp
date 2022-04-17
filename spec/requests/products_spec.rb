require 'rails_helper'

RSpec.describe 'Product' do
  describe 'GET /products_defer' do
    let!(:account) { create(:account) }
    let(:url) { '/products_defer' }

    context 'with pagination params' do
      let!(:products) { create_list(:product, 20, account_id: account.id) }

      let(:paginate_params) do
        {
          start: '0', length: '10',
          order: { '0': { column: '2', dir: 'asc' } }
        }
      end

      it 'returns 10 products' do
        login_user(account.user)
        get url, params: paginate_params

        expect(body_json['data'].count).to eq 10
      end

      it 'returns 10 first account products' do
        login_user(account.user)
        get url, params: paginate_params
        expect_products = products[0..9].sort! { |a,b| b[:id] <=> a[:id]}
                                        .as_json(only: %i(id))
                                        .map { |product| product['id'] }

        response = body_json['data'].map { |product| product['attributes']['id']  }

        expect(response).to contain_exactly(*expect_products)
      end

      it 'returns success :status' do
        login_user(account.user)
        get url, params: paginate_params

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
