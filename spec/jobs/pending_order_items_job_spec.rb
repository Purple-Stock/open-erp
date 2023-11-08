# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PendingOrderItemsJob, type: :job do
  let(:user) { FactoryBot.create(:user) }

  describe '#perform_now' do
    before do
      BlingOrderItem.destroy_all
      FactoryBot.create(:bling_datum, account_id: user.account.id, expires_at: Time.now + 2.day)
    end

    xit 'counts by 110 bling order items' do
      VCR.use_cassette('all_pending_order_items', erb: true) do
        expect do
          subject.perform(user.account.id)
        end.to change(BlingOrderItem, :count).by(110)
      end
    end

    context 'when there is no pending orders' do
      it 'counts by 100 bling order items' do
        VCR.use_cassette('all_pending_order_items', erb: true) do
          expect do
            subject.perform(user.account.id)
          end.to change(BlingOrderItem, :count).by(100)
        end
      end
    end

    context 'when there are pending orders' do
      before { subject.perform(user.account.id) }

      it 'counts by 0 bling order items' do
        VCR.use_cassette('all_pending_order_items', erb: true) do
          expect do
            subject.perform(user.account.id)
          end.to change(BlingOrderItem, :count).by(0)
        end
      end
    end
  end
end
