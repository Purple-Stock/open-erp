# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlingOrderItemCreatorJob, type: :job do
  let(:user) { FactoryBot.create(:user) }

  describe '#perform_now' do
    before do
      BlingOrderItem.destroy_all
      FactoryBot.create(:bling_datum, account_id: user.account.id, expires_at: Time.now + 2.day)
      allow(subject).to receive(:list_status_situation).and_return([15])
    end

    it 'counts by 93 bling order items' do
      VCR.use_cassette('all_situations_bling_order_items', erb: true) do
        expect do
          subject.perform(user.account.id)
        end.to change(BlingOrderItem, :count).by(93)
      end
    end
  end
end
