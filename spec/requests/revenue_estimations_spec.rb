# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RevenueEstimations', type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe 'GET /index' do
    before do
      sign_in user
      get revenue_estimations_path
    end

    it 'is success' do
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    before do
      sign_in user
      get new_revenue_estimation_path
    end

    it 'is success' do
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    let!(:revenue_estimation) { FactoryBot.create(:revenue_estimation) }

    before do
      sign_in user
      get edit_revenue_estimation_path(revenue_estimation)
    end

    it 'is success' do
      expect(response).to be_successful
    end
  end
end
