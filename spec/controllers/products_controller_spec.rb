require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe 'GET #index' do
    let!(:products) { create_list(:product, 3) }

    xit 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    xit 'assigns @products' do
      get :index
      expect(assigns(:products)).to eq(products)
    end
  end
end