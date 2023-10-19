# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InProgressOrderItemsJob, type: :job do
  let(:user) { FactoryBot.create(:user) }

  describe '#perform_now' do
    before do
      BlingOrderItem.destroy_all
      FactoryBot.create(:bling_datum, account_id: user.account.id, expires_at: Time.now + 2.day)
    end

    it 'counts by 96 bling order items' do
      VCR.use_cassette('all_in_progress_order_items', erb: true) do
        expect do
          subject.perform(user.account.id)
        end.to change(BlingOrderItem, :count).by(96)
      end
    end
  end
end
