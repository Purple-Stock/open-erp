require 'rails_helper'

RSpec.describe Account, type: :model do
  describe '#create' do
    subject(:create_valid) { FactoryBot.create(:account, user: user) }

    let!(:user) { FactoryBot.create(:user) }

    context 'when valid' do
      it 'creates account' do
        expect do
          create_valid
        end.to change(described_class, :count).by(1)
      end
    end
  end
end
