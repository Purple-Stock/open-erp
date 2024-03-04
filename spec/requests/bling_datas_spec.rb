# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'BlingData', type: :request do
  describe 'GET index' do
    include_context 'with user signed in'
    context 'when authorized' do
      include_context 'with bling feature'

      it 'has successfully response' do
        get bling_data_path
        expect(response).to have_http_status(:success)
      end
    end

    context 'when unauthorized' do
      it 'is a redirect response' do
        get bling_data_path
        expect(response).to redirect_to(products_path)
      end
    end
  end

  describe 'GET show' do
    include_context 'with user signed in'
    include_context 'with bling datum'

    before { get bling_datum_path(bling_datum) }

    context 'when authorized' do
      include_context 'with bling feature'

      it 'has successfully response' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'without bling feature' do
      it 'is a redirect response' do
        expect(response).to redirect_to(products_path)
      end
    end
  end
end
