# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'BlingData', type: :request do
  describe 'GET index' do
    include_context 'with user signed in'

    before { get bling_data_path }

    include_context 'with bling feature' do
      it 'has successfully response' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'without bling feature' do
      it 'is a redirect response' do
        expect(response).to redirect_to(:products_path)
      end
    end
  end

  describe 'GET show' do
    include_context 'with user signed in'
    include_context 'with bling datum'

    before { get bling_datum_path(bling_datum) }

    include_context 'with bling feature' do
      it 'has successfully response' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'without bling feature' do
      it 'is a redirect response' do
        expect(response).to redirect_to(:products_path)
      end
    end
  end
end
