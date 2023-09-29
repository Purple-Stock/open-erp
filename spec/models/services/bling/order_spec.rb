# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Bling::Order, type: :services do
  let(:account_id) { 1 }
  let!(:bling_datum) { FactoryBot.create(:bling_datum, account_id: account_id) }
  let(:order_command) { 'find_orders' }
  let(:situation) { 15 }

  describe '#initialize' do
    it 'is truthy' do
      expect(described_class.call(order_command: order_command, tenant: account_id, situation: situation)).to be_truthy
    end
  end
end
