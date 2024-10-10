# == Schema Information
#
# Table name: tailors
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
# Indexes
#
#  index_tailors_on_account_id  (account_id)
#
require 'rails_helper'

RSpec.describe Tailor, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      tailor = build(:tailor)
      expect(tailor).to be_valid
    end

    it 'is not valid without a name' do
      tailor = build(:tailor, name: nil)
      expect(tailor).to_not be_valid
    end

    it 'is not valid without an account' do
      tailor = build(:tailor, account: nil)
      expect(tailor).to_not be_valid
    end
  end

  describe 'associations' do
    it 'belongs to an account' do
      association = described_class.reflect_on_association(:account)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:tailor)).to be_valid
    end
  end
end
