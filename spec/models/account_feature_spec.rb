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
    before do
      FactoryBot.create(:feature, feature_key: FeatureKey::STOCK, name: 'Stock')
      FactoryBot.create(:feature, feature_key: FeatureKey::BLING_INTEGRATION, name: 'Bling Integration')
    end

    let!(:user) { FactoryBot.create(:user) }

    it 'is truthy for stock feature' do
      expect(user.account.account_features.first.is_enabled?).to eq(true)
    end

    it 'is false for bling integration feature' do
      expect(user.account.account_features.second.is_enabled?).to eq(false)
    end
  end
end
