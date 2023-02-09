# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Locales", type: :request do
  describe "GET /set_locale" do
    it "returns http found" do
      get set_locale_path
      expect(response).to have_http_status(:found)
    end  
  end  
end
