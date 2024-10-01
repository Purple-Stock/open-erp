# # frozen_string_literal: true

# require 'rails_helper'

# RSpec.describe 'Stocks', type: :request do
#   let(:user) { FactoryBot.create(:user) }
#   let(:product) { FactoryBot.create(:product, account_id: user.account.id) }

#   before do
#     # Mock Pagy to avoid pagination issues in tests
#     allow_any_instance_of(StocksController).to receive(:pagy_array).and_return([double('Pagy'), []])
#   end

#   describe 'GET /index' do
#     before do
#       FactoryBot.create_list(:stock, 10, product: product, account_id: user.account.id)
#       sign_in user
#     end

#     context 'when there is no filter' do
#       before { get stocks_path }

#       it 'is success' do
#         expect(response).to be_successful
#       end
#     end

#     context 'when filtering by status' do
#       before { get stocks_path, params: { status: '1' } }

#       it 'is success' do
#         expect(response).to be_successful
#       end
#     end
#   end

#   describe 'GET /show' do
#     let(:stock) { FactoryBot.create(:stock, product: product, account_id: user.account.id) }

#     before do
#       sign_in user
#       get stock_path(stock)
#     end

#     it 'is success' do
#       expect(response).to be_successful
#     end
#   end
# end
