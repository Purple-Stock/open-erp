# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CurrentDoneBlingOrderItemJob, type: :job do
  let(:user) { FactoryBot.create(:user) }

  describe '#perform_now' do
    before do
      allow(Rails).to receive(:env).and_return('no_test')
      BlingOrderItem.destroy_all
      FactoryBot.create(:bling_datum, account_id: user.account.id, expires_at: Time.now + 2.day)
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
