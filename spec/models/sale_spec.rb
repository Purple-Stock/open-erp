# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sale, type: :model do
  it { is_expected.to have_many(:sale_products) }

  it { is_expected.to belong_to(:account) }

  context 'when create' do
    let(:sale) { create(:sale) }

    it 'is valid' do
      expect(sale).to be_valid
    end
  end
end
