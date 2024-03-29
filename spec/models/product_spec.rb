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
#  bling_id    :bigint
#  category_id :bigint
#  custom_id   :integer
#  store_id    :integer
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
  let(:product) { create(:product) }

  describe 'associations' do
    it { is_expected.to have_many(:purchase_products) }
    it { is_expected.to have_many(:sale_products) }
    it { is_expected.to have_many(:group_products) }
    it { is_expected.to have_one_attached(:image) }
    it { is_expected.to have_many(:simplo_items) }
  end

  describe 'columns matcher' do
    it { is_expected.to have_db_column(:bling_id) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  end

  describe '#create' do
    let(:bling_id) { 16_181_499_539 }

    include_context 'when user account'

    it 'does not create stock' do
      VCR.use_cassette('bling_products_with_stock_by_product_ids', erb: true) do
        expect do
          FactoryBot.create(:product, bling_id:, account_id: user.account.id)
        end.to change(Stock, :count).by(0)
      end
    end
  end

  describe '#self.synchronize_bling' do
    let(:user) { FactoryBot.create(:user) }

    before { FactoryBot.create(:bling_datum, account_id: user.account.id) }

    context 'when there is no product' do
      it 'counts by 100' do
        VCR.use_cassette('bling_products_with_stock_by_product_ids', erb: true) do
          expect do
            described_class.synchronize_bling(user.account.id)
          end.to change(described_class, :count).by(100)
        end
      end
    end

    context 'when there is product' do
      let(:bling_product_id) { 16_181_499_539 }

      include_context 'when user account'

      before do
        VCR.use_cassette('bling_products_with_stock_by_product_ids', erb: true) do
          FactoryBot.create(:product, bling_id: bling_product_id, account_id: user.account.id, active: false)
        end
      end

      it 'counts by 99' do
        VCR.use_cassette('bling_products_with_stock_by_product_ids', erb: true) do
          expect do
            described_class.synchronize_bling(user.account.id)
          end.to change(described_class, :count).by(99)
        end
      end

      it 'has active turned true from bling data' do
        options = { idsProdutos: [bling_product_id] }

        VCR.use_cassette('bling_product_by_ids', erb: true) do
          described_class.synchronize_bling(user.account.id, options)
          expect(described_class.find_by(bling_id: bling_product_id)).to be_active
        end
      end
    end

    context 'when attributes' do
      before do
        VCR.use_cassette('bling_products_with_stock_by_product_ids', erb: true) do
          described_class.synchronize_bling(user.account.id)
        end
      end

      it 'has name' do
        expect(described_class.first.name).to eq('Faker Name Souza:Branco;Tamanho:G')
      end

      it 'has sku' do
        expect(described_class.first.sku).to eq('VEST-Brilho-Reveillon-BRANCO-G')
      end

      it 'has bling_id' do
        expect(described_class.first.bling_id).to eq(16_181_499_539)
      end

      it 'is active' do
        expect(described_class.first.active).to eq(true)
      end
    end
  end

  describe '#count_month_purchase_product' do
    include_context 'when user account'
    include_context 'with product'

    it 'returns the sum of quantities for purchase products in the given month' do
      year = Time.zone.now.year
      month = Time.zone.now.month
      FactoryBot.create(:purchase_product, product:, account: user.account, quantity: 5, created_at: Time.zone.local(year, month, 15))
      FactoryBot.create(:purchase_product, product:, account: user.account, quantity: 3, created_at: Time.zone.local(year, month, 20))
      expect(product.count_month_purchase_product(year, month)).to eq(8)
    end
  end

  describe '#datatable_filter' do
    let(:search_columns) { { '1' => { 'searchable' => true } } }
    let(:product_1) { create(:product, name: 'Widget') }
    let(:product_2) { create(:product, name: 'Gadget') }
    let(:products) { [product_1, product_2] }

    it 'returns products matching the given search value for the given search columns' do
      result = Product.datatable_filter('Widget', search_columns)
      expect(result).to contain_exactly(product_1)
    end

    it 'returns all products if the search value is blank' do
      result = Product.datatable_filter('', search_columns)
      expect(result).to contain_exactly(*products)
    end
  end

  describe '#count_month_sale_product' do
    let(:account) { create(:account) }

    it 'returns the sum of quantities for sale products in the given month' do
      year = Time.zone.now.year
      month = Time.zone.now.month
      create(:sale_product, product:, account:, quantity: 5, created_at: Time.zone.local(year, month, 15))
      create(:sale_product, product:, account:, quantity: 3, created_at: Time.zone.local(year, month, 20))

      expect(product.count_month_sale_product(year, month)).to eq(8)
    end
  end

  # describe '#sum_simplo_items' do
  #  it 'returns the sum of quantities for simplo items' do
  #    create(:simplo_item, product: product, quantity: 5)
  #    create(:simplo_item, product: product, quantity: 3)
  #    expect(product.sum_simplo_items).to eq(8)
  #  end
  # end

  context 'when create' do
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
end
