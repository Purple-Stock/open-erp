require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should have_many(:group_products) }
  it { should have_many(:simplo_items) }
  it { should have_many(:sale_products) }
  it { should belong_to(:category) }

  it { should validate_presence_of(:name) }

  context 'when create' do
    let(:product) { create(:product) }

    it 'should be valid' do
      expect(product).to be_valid
    end

    it 'should have a custom_id' do
      expect(product.custom_id).not_to be_nil
    end

    it 'should have a sku' do
      expect(product.sku).not_to be_nil
    end

    it 'should have a extra_sku' do
      expect(product.extra_sku).not_to be_nil
    end

    it 'should have a image' do
      expect(product.image).not_to be_nil
    end
  end

  context 'when update' do
    let(:product) { create(:product) }

    it 'should be valid' do
      expect(product).to be_valid
    end

  end

  context 'when destroy' do
    let(:product) { create(:product) }

    it 'should be valid' do
      expect(product).to be_valid
    end
  end

end
