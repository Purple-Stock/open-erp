require 'spec_helper'

shared_context 'with bling feature' do
  let(:feature_bling) { FactoryBot.create(:feature, feature_key: FeatureKey::BLING_INTEGRATION, is_enabled: true) }

  before do
    user.account.features << feature_bling
    user.account.account_features.first.update(is_enabled: true)
  end
end