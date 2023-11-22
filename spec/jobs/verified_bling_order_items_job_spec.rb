# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VerifiedBlingOrderItemsJob, type: :job do
  let(:user) { FactoryBot.create(:user) }

  describe '#perform_now' do
    before do
      allow(Date).to receive(:today).and_return Date.new(2023, 11, 15)
      FactoryBot.create(:bling_datum, account_id: user.account.id, expires_at: Time.zone.now + 2.days)
    end

    context 'when there is no verified orders' do
      it 'counts by 3255 bling order items' do
        VCR.use_cassette('all_verified_order_items', erb: true) do
          expect do
            subject.perform(user.account.id)
          end.to change(BlingOrderItem, :count).by(3255)
        end
      end
    end

    context 'when there are verified orders' do
      before do
        FactoryBot.create(:bling_order_item, bling_order_id: '18609813229',
                                             situation_id: BlingOrderItem::Status::PENDING)
      end

      it 'counts by 3254 bling order items' do
        VCR.use_cassette('all_verified_order_items', erb: true) do
          expect do
            subject.perform(user.account.id)
          end.to change(BlingOrderItem, :count).by(3254) # one already created.
        end
      end

      it 'has verified situation id' do
        VCR.use_cassette('all_verified_order_items', erb: true) do
          subject.perform(user.account.id)
          expect(BlingOrderItem.find_by(bling_order_id: '18609813229').situation_id.to_i)
            .to eq(BlingOrderItem::Status::VERIFIED)
        end
      end
    end
  end
end
