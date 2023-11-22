# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InProgressOrderItemsJob, type: :job do
  let(:user) { FactoryBot.create(:user) }

  describe '#perform_now' do
    before do
      FactoryBot.create(:bling_datum, account_id: user.account.id, expires_at: Time.now + 2.day)
    end

    context 'when there is no in progress orders' do
      it 'counts by 43 bling order items' do
        VCR.use_cassette('all_in_progress_order_items', erb: true) do
          expect do
            subject.perform(user.account.id)
          end.to change(BlingOrderItem, :count).by(43)
        end
      end
    end

    context 'when there are in progress orders' do
      before do
        FactoryBot.create(:bling_order_item, bling_order_id: '19178124416')
      end

      it 'counts by 86 bling order items' do
        VCR.use_cassette('all_in_progress_order_items', erb: true) do
          expect do
            subject.perform(user.account.id)
          end.to change(BlingOrderItem, :count).by(42) # one already created.
        end
      end

      it 'has status in progress' do
        VCR.use_cassette('all_in_progress_order_items', erb: true) do
          subject.perform(user.account.id)
          expect(BlingOrderItem.find_by(bling_order_id: '19178124416').situation_id.to_i)
            .to eq(BlingOrderItem::Status::IN_PROGRESS)
        end
      end
    end
  end
end
