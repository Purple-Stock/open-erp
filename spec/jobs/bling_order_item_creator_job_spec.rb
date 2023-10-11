require 'rails_helper'

RSpec.describe BlingOrderItemCreatorJob, type: :job do
  let(:user) { FactoryBot.create(:user) }

  describe '#create_in_progress_order_items' do
    before do
      subject.account_id = user.account.id
      FactoryBot.create(:bling_datum, account_id: user.account.id, expires_at: Time.now + 2.day)
    end

    it 'counts by 143 bling order items' do
      VCR.use_cassette('in_progress_oder_items_situation', erb: true) do
        expect do
          subject.send(:create_in_progress_order_items)
        end.to change(BlingOrderItem, :count).by(1)
      end
    end

    it 'counts by 0 checked bling order items' do
      VCR.use_cassette('checked_order_items_situation', erb: true) do
        expect do
          subject.send(:create_checked_order_items)
        end.to change(BlingOrderItem, :count).by(0)
      end
    end

    it 'counts by 0 pending bling order items' do
      VCR.use_cassette('pending_order_items_situation', erb: true) do
        expect do
          subject.send(:create_pending_order_items)
        end.to change(BlingOrderItem, :count).by(0)
      end
    end

    it 'counts by 8 printed bling order items' do
      VCR.use_cassette('printed_order_items_situation', erb: true) do
        expect do
          subject.send(:create_printed_order_items)
        end.to change(BlingOrderItem, :count).by(212)
      end
    end

    it 'counts by 220 verified bling order items' do
      VCR.use_cassette('verified_order_items_situation', erb: true) do
        expect do
          subject.send(:create_verified_order_items)
        end.to change(BlingOrderItem, :count).by(220)
      end
    end
  end
end
