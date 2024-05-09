# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SheinBlingOrderItems', type: :request do
  include_context 'with user signed in'

  describe 'GET /index' do
    before { get shein_bling_order_items_path }

    it 'is success' do
      expect(response).to be_successful
    end
  end
end
