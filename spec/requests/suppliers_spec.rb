# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Suppliers', type: :request do
  include_context 'with user signed in'

  describe 'GET /suppliers' do
    it 'is success' do
      get suppliers_url
      expect(response).to have_http_status(:success)
    end
  end
end
