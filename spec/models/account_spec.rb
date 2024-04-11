# == Schema Information
#
# Table name: accounts
#
#  id           :bigint           not null, primary key
#  company_name :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:account_features) }
    it { is_expected.to have_many(:features).through(:account_features) }
  end

  describe '#create' do
    let(:user) { FactoryBot.create(:user) }
    let(:account) { user.account }

    context 'when valid' do
      it 'creates account' do
        expect do
          user
        end.to change(described_class, :count).by(1)
      end
    end

    context 'when there is inventory feature' do
      let!(:inventory_feature) { FactoryBot.create(:feature, name: 'Inventory', feature_key: 0, is_enabled: true) }

      it 'creates association account_feature' do
        expect(account.features).to include(inventory_feature)
      end

      it 'has inventory feature enabled' do
        expect(account.features.first).to be_is_enabled
      end
    end
  end
end
