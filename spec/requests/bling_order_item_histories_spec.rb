# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "BlingOrderItemHistories", type: :request do
  let(:user) { FactoryBot.create(:user) }

  before { sign_in user }

  describe "GET /index" do
    it "returns http success" do
      get bling_order_item_histories_path
      expect(response).to have_http_status(:success)
    end
  end
end
