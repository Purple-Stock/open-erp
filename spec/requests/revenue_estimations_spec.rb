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

  describe 'POST /revenue_estimations' do
    let(:params) { { revenue_estimation: FactoryBot.attributes_for(:revenue_estimation) } }

    before do
      sign_in user
    end

    it 'is success' do
      post revenue_estimations_path(params)
      revenue_estimation = RevenueEstimation.last
      expect(response).to redirect_to revenue_estimation_path(revenue_estimation)
    end

    it 'counts by 1' do
      expect do
        post(revenue_estimations_path(params))
      end.to change(RevenueEstimation, :count).by(1)
    end
  end

  describe 'PUT /revenue_estimations' do
    let(:params) { { revenue_estimation: FactoryBot.attributes_for(:revenue_estimation, quantity: 2) } }
    let!(:revenue_estimation) { FactoryBot.create(:revenue_estimation) }

    before do
      sign_in user
    end

    it 'is redirected to show' do
      put revenue_estimation_path(revenue_estimation.id), params: params
      expect(response).to redirect_to revenue_estimation_path(revenue_estimation)
    end

    it 'counts by 0' do
      expect do
        put revenue_estimation_path(revenue_estimation.id), params: params
      end.to change(RevenueEstimation, :count).by(0)
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

  describe 'DELETE /revenue_estimations' do
    let!(:revenue_estimation) { FactoryBot.create(:revenue_estimation) }

    before do
      sign_in user
    end

    it 'is redirected to index' do
      delete revenue_estimation_path(revenue_estimation.id)
      expect(response).to redirect_to revenue_estimations_path
    end

    it 'counts by -1' do
      expect do
        delete revenue_estimation_path(revenue_estimation.id)
      end.to change(RevenueEstimation, :count).by(-1)
    end
  end
end
