require 'rails_helper'

RSpec.describe Product, type: :model do  
  it { should have_many(:group_products) }
  it { should have_many(:simplo_items) }
  it { should have_many(:sale_products) }
  it { should belong_to(:category) }

  it { should validate_presence_of(:price) }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { should validate_presence_of(:sku) }
  it { should validate_presence_of(:extra_sku) }
  it { should validate_presence_of(:custom_id) }
end
