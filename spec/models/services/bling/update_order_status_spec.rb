# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Bling::UpdateOrderStatus, type: :service do
  include_context 'with bling token'
  let(:collected_order_id) { 19_436_662_536 }
  let(:collected_status) { 173_631 }
  let(:order) { FactoryBot.create(:bling_order_item, bling_order_id: collected_order_id, account_id: user.account.id) }
  let(:order_ids) { [order.bling_order_id] }

  describe '#call' do
    subject(:call) { described_class.new(tenant: user.account.id, order_ids:, new_status: collected_status).call }

    it 'returns success' do
      VCR.use_cassette('update_order_status_collected', erb: true) do
        expect(call).to eq({ results: [{ order_id: collected_order_id.to_s, status: 'success' }] })
      end
    end
  end
end
