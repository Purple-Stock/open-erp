# == Schema Information
#
# Table name: bling_data
#
#  id            :bigint           not null, primary key
#  access_token  :string
#  expires_at    :datetime
#  expires_in    :integer
#  refresh_token :string
#  scope         :text
#  token_type    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  account_id    :integer
#
# Indexes
#
#  index_bling_data_on_account_id  (account_id)
#
require 'rails_helper'

RSpec.describe BlingDatum, type: :model do
  describe 'associations' do
    it { is_expected.to have_db_column(:account_id) }
    it { is_expected.to have_db_index(:account_id) }
  end

  describe 'create' do
    let(:expires_at) { Time.zone.local(13) }
    let(:bling_datum) { FactoryBot.create(:bling_datum, expires_at: expires_at) }

    context 'when it is valid' do
      it 'is valid' do
        expect(bling_datum).to be_valid
      end

      it 'is has expires date' do
        expect(bling_datum.expires_at).to eq(expires_at)
      end
    end
  end
end
