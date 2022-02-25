require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should have_many(:group_products) }
  it { should have_many(:simplo_items) }
  it { should have_many(:sale_products) }
  it { should belong_to(:category) }

  it { should validate_presence_of(:name) }
end
