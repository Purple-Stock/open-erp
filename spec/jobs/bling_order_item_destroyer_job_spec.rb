# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlingOrderItemDestroyerJob, type: :job do
  include_context 'with bling token'
  let(:found_bling_order_id) { '19178587026' }
  let(:bling_order_item) { FactoryBot.create(:bling_order_item, account_id: user.account.id) }

  describe '#perform' do
    context 'when bling order is found at bling' do
      before do
        VCR.use_cassette('found_at_bling', erb: true) do
          bling_order_item.update(bling_order_id: found_bling_order_id)
          bling_order_item.deleted_at_bling!
        end
      end

      it 'changes status to previous one' do
        expect(bling_order_item.reload.situation_id).to eq(BlingOrderItemStatus::CHECKED)
      end
    end

    context 'when resource is not found at bling' do
      let(:not_found_order_id) { '99' }

      before do
        VCR.use_cassette('not_found_at_bling', erb: true) do
          bling_order_item.update(bling_order_id: not_found_order_id)
          bling_order_item.deleted_at_bling!
        end
      end

      it 'changes situation_id to DELETE_AT_BLING' do
        expect(bling_order_item.reload.situation_id).to eq(BlingOrderItemStatus::DELETED_AT_BLING)
      end
    end
  end
end
