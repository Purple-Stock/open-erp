# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CollectedBlingOrderItemsJob, type: :job do
  let(:user) { FactoryBot.create(:user) }

  describe '#perform' do
    before do
      allow_any_instance_of(BlingOrderItem).to receive(:synchronize_items).and_return(true)
      allow(Date).to receive(:today).and_return Date.new(2024, 1, 15)
      FactoryBot.create(:bling_datum, account_id: user.account.id, expires_at: Time.zone.now + 2.days)
    end

    context 'when there are collected orders' do
      before do
        VCR.use_cassette('all_collected_order_items', erb: true) do
          subject.perform(user.account.id, (Date.today - 2.days))
        end
      end

      it 'counts by 1 bling order items' do
        expect(BlingOrderItem.count).to eq(1)
      end

      it 'has collected situation id' do
        expect(BlingOrderItem.find_by(bling_order_id: '19508913684').situation_id.to_i)
          .to eq(BlingOrderItem::Status::COLLECTED)
      end

      it 'has collected alteration date' do
        expect(BlingOrderItem.find_by(bling_order_id: '19508913684').collected_alteration_date.to_date)
          .to eq(Date.today)
      end

      it 'has alteration date' do
        expect(BlingOrderItem.find_by(bling_order_id: '19508913684').alteration_date.to_date)
          .to eq(Date.today)
      end
    end
  end
end
