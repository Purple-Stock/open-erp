# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CurrentDoneBlingOrderItemJob, type: :job do
  let(:user) { FactoryBot.create(:user) }

  describe '#perform_now' do
    before do
      allow(Date).to receive(:today).and_return Date.new(2023, 10, 20)
      allow(Rails).to receive(:env).and_return('no_test')
      BlingOrderItem.destroy_all
      FactoryBot.create(:bling_datum, account_id: user.account.id, expires_at: Time.now + 2.day)
    end

    context 'when there is a pending bling order item in local database' do
      before do
        FactoryBot.create(:bling_order_item, bling_order_id: 18969858161,
                                             situation_id: BlingOrderItem::Status::PENDING)
      end

      it 'counts by 319 bling order items' do
        VCR.use_cassette('verified_checked_order_items_situation', erb: true) do
          expect do
            subject.perform(user.account.id)
          end.to change(BlingOrderItem, :count).by(319)
        end
      end

      it 'has alteration date present' do
        VCR.use_cassette('verified_checked_order_items_situation', erb: true) do
          subject.perform(user.account.id)
          expect(BlingOrderItem.first.alteration_date).to be_present
        end
      end

      it 'has situation changed to checked' do
        VCR.use_cassette('verified_checked_order_items_situation', erb: true) do
          subject.perform(user.account.id)
          expect(BlingOrderItem.first.situation_id.to_i).to eq(BlingOrderItem::Status::CHECKED)
        end
      end
    end

    it 'counts by 320 bling order items' do
      VCR.use_cassette('verified_checked_order_items_situation', erb: true) do
        expect do
          subject.perform(user.account.id)
        end.to change(BlingOrderItem, :count).by(320)
      end
    end

    it 'counts by 308 grouped by bling_order_id' do
      VCR.use_cassette('verified_checked_order_items_situation', erb: true) do
        subject.perform(user.account.id)

        expect(BlingOrderItem.all.group_by(&:bling_order_id).keys.length).to eq(308)
      end
    end

    it 'has alteration_date day equal to 20' do
      VCR.use_cassette('verified_checked_order_items_situation', erb: true) do
        subject.perform(user.account.id)

        expect(BlingOrderItem.first.alteration_date.day).to eq(20)
      end
    end
  end
end
