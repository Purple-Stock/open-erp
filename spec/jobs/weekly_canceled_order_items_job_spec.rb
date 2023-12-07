# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeeklyCanceledOrderItemsJob, type: :job do
  let(:user) { FactoryBot.create(:user) }

  describe '#perform_now' do
    before do
      FactoryBot.create(:bling_datum, account_id: user.account.id, expires_at: Time.now + 2.day)
    end

    context 'when date range option is given' do
      let!(:options) { { dataInicial: '2023-11-1', dataFinal: '2023-11-1' } }

      it 'counts by 100 bling order items' do
        VCR.use_cassette('all_canceled_order_items_date_range', erb: true) do
          expect do
            subject.perform(user.account.id, options)
          end.to change(BlingOrderItem, :count).by(100)
        end
      end
    end

    context 'when there are canceled orders' do
      let!(:options) { { dataInicial: '2023-11-1', dataFinal: '2023-11-1' } }

      before do
        FactoryBot.create(:bling_order_item, bling_order_id: '19048562827', value: nil)
      end

      it 'counts by 99 bling order items' do
        VCR.use_cassette('all_canceled_order_items_date_range', erb: true) do
          expect do
            subject.perform(user.account.id, options)
          end.to change(BlingOrderItem, :count).by(100 - 1) # one already created.
        end
      end

      it 'has status canceled' do
        VCR.use_cassette('all_canceled_order_items_date_range', erb: true) do
          subject.perform(user.account.id, options)
          expect(BlingOrderItem.find_by(bling_order_id: '19048562827').situation_id.to_i)
            .to eq(BlingOrderItem::Status::CANCELED)
        end
      end
    end
  end
end
