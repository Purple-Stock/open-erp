require 'rails_helper'

RSpec.describe Sale, type: :model do
  it { should have_many(:sale_products) }

  it { should belong_to(:account) }

  context 'when create' do
    let(:sale) { create(:sale) }

    it 'should be valid' do
      expect(sale).to be_valid
    end
  end

end
