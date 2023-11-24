# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrintedOrderItemsJob, type: :job do
  let(:user) { FactoryBot.create(:user) }

  describe '#perform_now' do
    before do
      BlingOrderItem.destroy_all
      FactoryBot.create(:bling_datum, account_id: user.account.id, expires_at: Time.now + 2.day)
    end

    context 'when there is no printed orders' do
      it 'counts by 100 bling order items' do
        VCR.use_cassette('all_printed_order_items', erb: true) do
          expect do
            subject.perform(user.account.id)
          end.to change(BlingOrderItem, :count).by(100)
        end
      end
    end

    context 'when there are printed orders' do
      before do
        FactoryBot.create(:bling_order_item, bling_order_id: '19191688711')
      end

      it 'counts by 99 bling order items' do
        VCR.use_cassette('all_printed_order_items', erb: true) do
          expect do
            subject.perform(user.account.id)
          end.to change(BlingOrderItem, :count).by(99) # one already created.
        end
      end
    end
  end
end
