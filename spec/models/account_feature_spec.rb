# == Schema Information
#
# Table name: account_features
#
#  id         :bigint           not null, primary key
#  is_enabled :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint           not null
#  feature_id :integer          not null
#
require 'rails_helper'

RSpec.describe AccountFeature, type: :model do
  describe '#is_enabled?' do
    let!(:feature) { FactoryBot.create(:feature, feature_key: FeatureKey::STOCK, name: 'Stockist') }
    let!(:user) { FactoryBot.create(:user) }

    context 'when feature key is STOCK' do
      it 'is truthy' do
        expect(user.account.account_features.first.is_enabled?).to eq(true)
      end
    end

    context 'when feature key is BLING_INTEGRATION' do
      before { feature.update(feature_key: FeatureKey::BLING_INTEGRATION) }

      it 'is false' do
        expect(user.account.account_features.first.is_enabled?).to eq(false)
      end
    end
  end
end
