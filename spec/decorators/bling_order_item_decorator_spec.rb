# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlingOrderItemDecorator, type: :decorator do
  let(:bling_order) { FactoryBot.create(:bling_order_item) }
  let(:bling_order_id) { bling_order.bling_order_id }
  let(:bling_order_decorated) { bling_order.decorate }

  describe '#title' do
    it 'decorates bling_order_id' do
      title = "#{t('activerecord.attributes.bling_order_items.bling_order_id')} #{bling_order_id}"
      expect(bling_order_decorated.title).to eq(title)
    end
  end
end
