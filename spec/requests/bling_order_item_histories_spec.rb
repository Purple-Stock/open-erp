require 'rails_helper'

RSpec.describe "BlingOrderItemHistories", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/bling_order_item_histories/index"
      expect(response).to have_http_status(:success)
    end
  end

end
