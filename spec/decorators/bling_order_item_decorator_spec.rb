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

  describe '#situation_id' do
    it 'is humanized' do
      expect(bling_order_decorated.situation_id).to eq(t('enumerations.bling_order_item_status.checked'))
    end
  end

  describe '#store_id' do
    it 'is humanized' do
      expect(bling_order_decorated.store_id).to eq('Shein')
    end
  end

  describe '#created_at' do
    it 'uses default locales' do
      expect(bling_order_decorated.created_at).to eq(localize(bling_order.created_at, format: :default))
    end
  end

  describe '#updated_at' do
    it 'uses default locales' do
      expect(bling_order_decorated.updated_at).to eq(localize(bling_order.updated_at, format: :default))
    end
  end

  describe '#date' do
    it 'uses default locales' do
      expect(bling_order_decorated.date).to eq(localize(bling_order.date, format: :short))
    end
  end

  describe '#alteration_date' do
    context 'when there is alteration date' do
      it 'uses short locales' do
        expect(bling_order_decorated.alteration_date).to eq(localize(bling_order.alteration_date, format: :short))
      end
    end

    context 'when alteration date is blank' do
      before { bling_order.alteration_date = nil }

      it 'shows warning about blank alteration date' do
        expect(bling_order_decorated.alteration_date).to be_blank
      end
    end
  end

  describe '#value' do
    it 'uses default locales' do
      expect(bling_order_decorated.value).to eq(number_to_currency(bling_order.value))
    end
  end

  describe '#situations_for_select' do
    let(:paired_array_humanized_situation_id) do
      [
        [t('enumerations.bling_order_item_status.in_progress'), '15'],
        [t('enumerations.bling_order_item_status.checked'), '101065'],
        [t('enumerations.bling_order_item_status.verified'), '24'],
        [t('enumerations.bling_order_item_status.pending'), '94871'],
        [t('enumerations.bling_order_item_status.printed'), '95745'],
        [t('enumerations.bling_order_item_status.canceled'), '12'],
        [t('enumerations.bling_order_item_status.collected'), '173631']
      ]
    end

    it 'is an array of humanized situation and situation_id' do
      expect(bling_order_decorated.situations_for_select).to eq(paired_array_humanized_situation_id)
    end
  end
end
