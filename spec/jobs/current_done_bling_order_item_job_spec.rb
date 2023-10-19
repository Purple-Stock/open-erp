# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CurrentDoneBlingOrderItemJob, type: :job do
  let(:user) { FactoryBot.create(:user) }

  describe '#perform_now' do
    before do
      allow(Date).to receive(:today).and_return Date.new(2023, 10, 13)
      BlingOrderItem.destroy_all
      FactoryBot.create(:bling_datum, account_id: user.account.id, expires_at: Time.now + 2.day)
    end

    xit 'counts by 191 bling order items' do
      VCR.use_cassette('verified_checked_order_items_situation', erb: true) do
        expect do
          subject.perform(user.account.id)
        end.to change(BlingOrderItem, :count).by(191)
      end
    end
  end
end
