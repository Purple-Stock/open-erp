require 'rails_helper'

RSpec.describe "Locales", type: :request do
  describe "GET /set_locale" do
    it "returns http success" do
      get "/locales/set_locale"
      expect(response).to have_http_status(:success)
    end
  end

end
