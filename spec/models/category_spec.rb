require 'rails_helper'

RSpec.describe Category, type: :model do

  it 'save without account' do
    category = Category.new(name: 'Vestido')
    expect(category).to_not be_valid
  end
end
