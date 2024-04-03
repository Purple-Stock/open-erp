# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ErrorDecorator do
  let(:purchase_product) { FactoryBot.build(:purchase_product, quantity: 0) }
  let(:pretty_message) do
    purchase_product.valid?
    purchase_product.errors.full_messages.join(', ')
  end

  describe '#full_messages' do
    before { purchase_product.valid? }

    it 'humanizes message' do
      expect(described_class.new(purchase_product.errors).full_messages).to eq(pretty_message)
    end
  end
end
