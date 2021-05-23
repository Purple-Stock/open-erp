require 'rails_helper'

RSpec.describe Category, type: :model do

  it 'save the correct data' do
    account = Account.create(company_name: 'Empresa teste')

    category = Category.new(name: 'Vestido', account_id: account.id)

    expect(category).to be_valid
  end

  it 'save without account' do
    category = Category.new(name: 'Vestido')

    expect(category).to_not be_valid
  end
end
