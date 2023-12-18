# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyCanceledOrderJob, type: :job do
  let(:user) { FactoryBot.create(:user) }
  let(:date) { Date.new(2023, 11, 22) }
  let(:alteration_date) { Date.new(2023, 12, 14) }
  let(:situation_id) { BlingOrderItem::Status::PENDING }
  let(:bling_order_id) { '19178587026' }

  describe '#perform' do
    before do
      allow(Rails).to receive(:env).and_return('no_test')
      allow(Date).to receive(:today).and_return Date.new(2023, 12, 14)
      FactoryBot.create(:bling_datum, account_id: user.account.id, expires_at: Time.zone.now + 2.days)
      FactoryBot.create(:bling_order_item, bling_order_id:, date:, situation_id:)
    end

    it 'has status canceled' do
      VCR.use_cassette('canceled_by_initial_alteration_date', erb: true) do
        subject.perform(user.account.id)
        expect(BlingOrderItem.find_by(bling_order_id:).situation_id.to_i)
          .to eq(BlingOrderItem::Status::CANCELED)
      end
    end

    it 'is equal to alteration_date' do
      VCR.use_cassette('canceled_by_initial_alteration_date', erb: true) do
        subject.perform(user.account.id)
        expect(BlingOrderItem.find_by(bling_order_id:).alteration_date.to_date)
          .to eq(alteration_date)
      end
    end
  end
end
