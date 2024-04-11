# frozen_string_literal: true

require 'spec_helper'

shared_context 'when user account' do
  let(:user) { FactoryBot.create(:user) }

  before { FactoryBot.create(:bling_datum, account_id: user.account.id) }
end

shared_context 'with bling token' do
  let(:user) { FactoryBot.create(:user) }

  before { FactoryBot.create(:bling_datum, account_id: user.account.id) }
end

shared_context 'with bling datum' do
  let(:bling_datum) { FactoryBot.create(:bling_datum, account_id: user.account.id) }
end
