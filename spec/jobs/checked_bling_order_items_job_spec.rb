# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckedBlingOrderItemsJob, type: :job do
  let(:user) { FactoryBot.create(:user) }

  describe '#perform' do
    before do
      allow(Date).to receive(:today).and_return Date.new(2023, 11, 15)
      FactoryBot.create(:bling_datum, account_id: user.account.id, expires_at: Time.zone.now + 2.days)
    end

    context 'when there are checked orders' do
      before do
        VCR.use_cassette('all_checked_order_items', erb: true) do
          subject.perform(user.account.id)
        end
      end

      it 'counts by 3353 bling order items' do
        expect(BlingOrderItem.count).to eq(3353)
      end

      it 'has checked situation id' do
        expect(BlingOrderItem.find_by(bling_order_id: '18621253255').situation_id.to_i)
          .to eq(BlingOrderItem::Status::CHECKED)
      end
    end

    context 'when argument has alteration date' do
      before do
        VCR.use_cassette('all_checked_order_items', erb: true) do
          subject.perform(user.account.id, (Date.today - 2.days))
        end
      end

      it 'counts by 208 bling order items' do
        expect(BlingOrderItem.count).to eq(208)
      end
    end
  end
end
