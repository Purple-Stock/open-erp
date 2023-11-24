# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'orders control' do
  context 'when get root_path' do
    let(:user) { FactoryBot.create(:user) }

    before do
      FactoryBot.create(:bling_order_item, valor: 10.5, store_id: '204061683', situation_id: '94871',
                                           date: Time.zone.today, bling_order_id: Faker::Number.number,
                        account_id: user.account.id)
      FactoryBot.create(:bling_datum, account_id: user.account.id, expires_at: Time.zone.now + 2.days,
                        account_id: user.account.id)
      sign_in user
    end

    it 'is a successful response' do
      get root_path
      expect(response).to be_successful
    end

    context 'when there is at least 1 in progress order items' do
      before do
        FactoryBot.create(:bling_order_item, valor: 10.5, store_id: '204061683',
                                             situation_id: BlingOrderItem::Status::IN_PROGRESS,
                                             bling_order_id: Faker::Number.number)
      end

      it 'is a successful response' do
        get root_path
        expect(response).to be_successful
      end
    end

    context 'when there is at least 1 canceled order items' do
      before do
        FactoryBot.create(:bling_order_item, valor: 10.5, store_id: '204061683',
                                             situation_id: BlingOrderItem::Status::CANCELED,
                                             bling_order_id: Faker::Number.number,
                                             account_id: user.account.id)
      end

      it 'is a successful response' do
        get root_path
        expect(response).to be_successful
      end
    end

    context 'when there is at least 1 checked order items' do
      before do
        FactoryBot.create(:bling_order_item, valor: 10.5, store_id: '204061683',
                                             situation_id: BlingOrderItem::Status::CHECKED,
                                             bling_order_id: Faker::Number.number)
      end

      it 'is a successful response' do
        get root_path
        expect(response).to be_successful
      end
    end

    context 'when there is at least 2 current done order items' do
      before do
        FactoryBot.create(:bling_order_item, valor: 10.5, store_id: '204061683',
                                             situation_id: BlingOrderItem::Status::CHECKED,
                                             bling_order_id: Faker::Number.number,
                                             alteration_date: Time.zone.today)
      end

      it 'is a successful response' do
        get root_path
        expect(response).to be_successful
      end
    end
  end
end
