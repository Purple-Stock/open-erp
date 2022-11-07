# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  active      :boolean
#  bar_code    :string
#  extra_sku   :string
#  highlight   :boolean
#  name        :string
#  price       :float
#  sku         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :integer
#  category_id :integer
#  custom_id   :integer
#
# Indexes
#
#  index_products_on_account_id   (account_id)
#  index_products_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
require 'rails_helper'

RSpec.describe Product, type: :model do
  it { is_expected.to have_many(:group_products) }
  it { is_expected.to have_many(:simplo_items) }
  it { is_expected.to have_many(:sale_products) }
  it { is_expected.to belong_to(:category) }

  it { is_expected.to validate_presence_of(:name) }

  context 'when create' do
    let(:product) { create(:product) }

    it 'is valid' do
      expect(product).to be_valid
    end

    it 'has a custom_id' do
      expect(product.custom_id).not_to be_nil
    end

    it 'has a sku' do
      expect(product.sku).not_to be_nil
    end

    it 'has a extra_sku' do
      expect(product.extra_sku).not_to be_nil
    end

    it 'has a image' do
      expect(product.image).not_to be_nil
    end
  end

  context 'when update' do
    let(:product) { create(:product) }

    it 'is valid' do
      expect(product).to be_valid
    end
  end

  context 'when destroy' do
    let(:product) { create(:product) }

    it 'is valid' do
      expect(product).to be_valid
    end
  end
end
