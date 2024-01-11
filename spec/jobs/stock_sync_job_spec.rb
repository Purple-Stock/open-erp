# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StockSyncJob, type: :job do
  describe '#perform' do
    include_context 'when user account'
    before { FactoryBot.create(:product) }

    it 'creates stock' do
      VCR.use_cassette('bling_stocks', erb: true) do
        expect do
          described_class.perform_later(user.account.id)
        end.to change(Stock, :count).by(1)
      end
    end
  end
end
