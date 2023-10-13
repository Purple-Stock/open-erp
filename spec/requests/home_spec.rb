# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'orders control' do
  context 'when get root_path' do
    let(:user) { FactoryBot.create(:user) }

    before do
      FactoryBot.create_list(:bling_order_item, 2, valor: 10.5, store_id: '204061683', situation_id: '94871',
                             date: Time.zone.today)
      FactoryBot.create(:bling_datum, account_id: user.account.id, expires_at: Time.now + 2.day)
      sign_in user
      get root_path
    end

    it 'is a successful response' do
      expect(response).to be_successful
    end
  end
end
