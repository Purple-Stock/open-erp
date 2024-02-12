# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboards', type: :request do

  describe 'GET /others_status' do
    include_context 'with user signed in'
    let(:feature_bling) { FactoryBot.create(:feature, feature_key: FeatureKey::BLING_INTEGRATION, is_enabled: true) }

    before do
      user.account.features << feature_bling
      user.account.account_features.first.update(is_enabled: true)
    end

    it 'returns http success' do
      get '/dashboards/others_status'
      expect(response).to have_http_status(:success)
    end
  end
end
