# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CancelledOrderItemsJob, type: :job do
  let(:user) { FactoryBot.create(:user) }

  describe '#perform_now' do
    before do
      FactoryBot.create(:bling_datum, account_id: user.account.id, expires_at: Time.now + 2.day)
    end

    context 'when there is no cancelled orders' do
      it 'counts by 87 bling order items' do
        VCR.use_cassette('all_cancelled_order_items', erb: true, record: :all) do
          expect do
            subject.perform(user.account.id)
          end.to change(BlingOrderItem, :count).by(100)
        end
      end
    end

    context 'when there are cancelled orders' do
      before do
        FactoryBot.create(:bling_order_item, bling_order_id: '19091628770')
      end

      it 'counts by 86 bling order items' do
        VCR.use_cassette('all_cancelled_order_items', erb: true) do
          expect do
            subject.perform(user.account.id)
          end.to change(BlingOrderItem, :count).by(99) # one already created.
        end
      end
    end
  end
end
