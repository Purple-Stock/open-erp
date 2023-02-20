# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
# Indexes
#
#  index_categories_on_account_id  (account_id)
#
require 'rails_helper'

RSpec.describe Category, type: :model do
  it 'save the correct data' do
    category = create(:category)
    expect(category).to be_valid
  end

  it 'save without account' do
    category = described_class.new(name: Faker::Lorem.word)
    expect(category).not_to be_valid
  end

  it 'category is not valid without name' do
    account = create(:account)
    category = described_class.new(name: nil, account_id: account.id)
    expect(category).not_to be_valid
  end
end
