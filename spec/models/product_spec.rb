require 'rails_helper'

RSpec.describe Product, type: :model do
  it 'save the correct data' do
    product = create(:product)
    expect(product).to be_valid
  end

  it 'save without account' do
    product = Product.new(name: FFaker::Internet.slug)
    expect(product).to_not be_valid
  end

  it 'product is not valid without name' do
    product = Product.new(name: nil)
    expect(product).to_not be_valid
  end
end
