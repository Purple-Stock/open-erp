# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Stocks', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:product) { FactoryBot.create(:product) }

  before { allow_any_instance_of(Product).to receive(:create_stock).and_return(true) }


  describe 'GET /index' do
    before do
      FactoryBot.create_list(:stock, 2, product:)
      sign_in user
      get stocks_path
    end

    it 'is success' do
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    let(:stock) { FactoryBot.create(:stock, product:) }

    before do
      sign_in user
      get stock_path(stock)
    end

    it 'is success' do
      expect(response).to be_successful
    end
  end
end
