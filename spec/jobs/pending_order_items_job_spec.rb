# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PendingOrderItemsJob, type: :job do
  let(:user) { FactoryBot.create(:user) }

  describe '#perform_now' do
    before do
      FactoryBot.create(:bling_datum, account_id: user.account.id, expires_at: Time.now + 2.day)
    end

    context 'when max page option is given' do
      let!(:options) { { max_pages: 1 } }

      it 'counts by 100 bling order items' do
        VCR.use_cassette('all_pending_order_items', erb: true) do
          expect do
            subject.perform(user.account.id, options)
          end.to change(BlingOrderItem, :count).by(100)
        end
      end
    end

    context 'when date range option is given' do
      let!(:options) { { dataInicial: '2023-11-1', dataFinal: '2023-11-1' } }

      it 'counts by 100 bling order items' do
        VCR.use_cassette('all_pending_order_items_date_range', erb: true) do
          expect do
            subject.perform(user.account.id, options)
          end.to change(BlingOrderItem, :count).by(2)
        end
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
      before do
        FactoryBot.create(:bling_order_item, bling_order_id: '18964504312')
      end

      it 'counts by 99 bling order items' do
        VCR.use_cassette('all_pending_order_items', erb: true) do
          expect do
            subject.perform(user.account.id)
          end.to change(BlingOrderItem, :count).by(100 - 1) # one already created.
        end
      end

      it 'has status pending' do
        VCR.use_cassette('all_pending_order_items', erb: true) do
          subject.perform(user.account.id)
          expect(BlingOrderItem.find_by(bling_order_id: '18964504312').situation_id.to_i)
            .to eq(BlingOrderItem::Status::PENDING)
        end
      end

      it 'has account id' do
        VCR.use_cassette('all_pending_order_items', erb: true) do
          subject.perform(user.account.id)
          expect(BlingOrderItem.find_by(account_id: user.account.id).account_id)
            .to eq(user.account.id)
        end
      end
    end
  end
end
