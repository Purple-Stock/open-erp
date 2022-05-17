require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { should have_many(:sales) }

  it { should belong_to(:account) }

  context 'when create' do
    let(:customer) { create(:customer) }

    it 'should be valid' do
      expect(customer).to be_valid
    end
  end

end
