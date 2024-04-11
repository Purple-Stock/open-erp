# == Schema Information
#
# Table name: stocks
#
#  id                    :bigint           not null, primary key
#  total_balance         :integer
#  total_virtual_balance :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  account_id            :integer
#  bling_product_id      :bigint
#  product_id            :integer
#
require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe '#associations' do
    it { is_expected.to belong_to(:product) }
  end

  describe '#has column names' do
    it { is_expected.to have_db_column(:bling_product_id) }
    it { is_expected.to have_db_column(:total_balance) }
    it { is_expected.to have_db_column(:total_virtual_balance) }
  end

  describe '#validations' do
    it { is_expected.to validate_numericality_of(:bling_product_id).only_integer }
    it { is_expected.to validate_numericality_of(:total_balance).only_integer }
    it { is_expected.to validate_numericality_of(:total_virtual_balance).only_integer }
  end

  describe '#save' do
    let(:bling_product_id) { 16_181_499_539 }
    let(:product) { FactoryBot.create(:product, bling_id: bling_product_id) }

    it 'is true' do
      attributes = { bling_product_id: product.id, total_balance: 30, total_virtual_balance: 30 }
      stock = described_class.new(attributes)
      product.stock = stock
      expect(stock.save).to be_truthy
    end
  end

  describe '#Self.filter_by_status' do
    include_context 'when user account'
    include_context 'with product'
    let(:inactive_product) { FactoryBot.create(:product, active: false) }
    let!(:stock) { FactoryBot.create(:stock, product: product) }
    let!(:inactive_stock) { FactoryBot.create(:stock, product: inactive_product) }

    context 'when active' do
      subject(:filter_by_active_status) { described_class.filter_by_status(1) }

      it 'includes stock' do
        expect(filter_by_active_status).to include(stock)
      end

      it 'does not include inactive stock' do
        expect(filter_by_active_status).not_to include(inactive_stock)
      end
    end

    context 'when inactive' do
      subject(:filter_by_inactive_status) { described_class.filter_by_status(0) }

      it 'does not include stock' do
        expect(filter_by_inactive_status).not_to include(stock)
      end

      it 'includes inactive stock' do
        expect(filter_by_inactive_status).to include(inactive_stock)
      end
    end

    context 'when all status' do
      subject(:filter_by_inactive_status) { described_class.filter_by_status }

      it 'includes both stock and inactive stock' do
        expect(filter_by_inactive_status).to include(stock, inactive_stock)
      end
    end
  end

  describe '#Self.only_positive_price' do
    include_context 'with product'
    let(:stock) { FactoryBot.create(:stock, product: product) }
    let(:zero_price_product) { FactoryBot.create(:product, price: 0) }
    let(:zero_price_stock) { FactoryBot.create(:stock, product: zero_price_product) }


    context 'when only positive price is true' do
      subject(:only_positive_price) { described_class.only_positive_price(true) }

      it 'includes stock' do
        expect(only_positive_price).to include(stock)
      end

      it 'does not include zero price stock' do
        expect(only_positive_price).not_to include(zero_price_stock)
      end
    end

    context 'when only positive price is false' do
      subject(:all_stock_price) { described_class.only_positive_price(false) }

      it 'includes all stocks' do
        expect(all_stock_price).to include(stock, zero_price_stock)
      end
    end
  end

  describe '#Self.filter_by_total_balance_situation' do
    include_context 'when user account'
    include_context 'with product'

    let!(:stock_positive) { FactoryBot.create(:stock, product: product, total_balance: 100) }
    let!(:stock_zero) { FactoryBot.create(:stock, product: product, total_balance: 0) }
    let!(:stock_negative) { FactoryBot.create(:stock, product: product, total_balance: -10) }


    context 'when filtering by positive balance' do
      subject(:positive_filter) { described_class.filter_by_total_balance_situation(1) }

      it 'has stock positive' do
        expect(positive_filter).to include(stock_positive)
      end

      it 'does not have neither stock zero nor negative stock' do
        expect(positive_filter).not_to include(stock_negative, stock_zero)
      end
    end

    context 'when filtering by negative balance' do
      subject(:negative_filter) { described_class.filter_by_total_balance_situation(-1) }

      it 'has stock negative' do
        expect(negative_filter).to include(stock_negative)
      end

      it 'does not have neither stock zero nor positive stocks' do
        expect(negative_filter).not_to include(stock_positive, stock_zero)
      end
    end

    context 'when filtering by zero balance' do
      subject(:zero_filter) { described_class.filter_by_total_balance_situation(0) }

      it 'has stock zero' do
        expect(zero_filter).to include(stock_zero)
      end

      it 'does not have neither stock positive nor negative stock' do
        expect(zero_filter).not_to include(stock_positive, stock_negative)
      end
    end

    context 'when filtering by all' do
      subject(:by_all_filter) { described_class.filter_by_total_balance_situation }

      it 'includes all balances' do
        expect(by_all_filter).to include(stock_positive, stock_negative, stock_zero)
      end
    end
  end

  describe '#self.synchronize_bling' do
    let(:bling_product_id) { 16_181_499_539 }
    let(:product_ids) { [bling_product_id] }
    let(:product) { FactoryBot.create(:product, bling_id: bling_product_id, account_id: user.account.id) }

    include_context 'with bling token'

    before do
      FactoryBot.create(:product, bling_id: bling_product_id, account_id: user.account.id)
    end

    context 'with products' do
      it 'creates stock' do
        VCR.use_cassette('bling_stocks', erb: true) do
          expect do
            described_class.synchronize_bling(user.account.id, product_ids)
          end.to change(described_class, :count).by(1)
        end
      end
    end

    context 'with stock to be updated' do
      before do
        described_class.new(bling_product_id: product.bling_id, total_balance: 50, total_virtual_balance: 50).save
      end

      it 'updates total_balance' do
        VCR.use_cassette('bling_stocks', erb: true) do
          described_class.synchronize_bling(user.account.id, product_ids)
          expect(described_class.find_by(bling_product_id:).total_balance).to eq(30)
        end
      end
    end

    context 'when attributes' do
      before do
        VCR.use_cassette('bling_stocks', erb: true) do
          described_class.synchronize_bling(user.account.id, product_ids)
        end
      end

      it 'has bling_product_id' do
        expect(described_class.first.bling_product_id).to eq(bling_product_id)
      end

      it 'has bling_id' do
        expect(described_class.first.bling_id).to eq(bling_product_id)
      end

      it 'has total_balance' do
        expect(described_class.first.total_balance).to eq(30)
      end

      it 'has total_virtual_balance' do
        expect(described_class.first.total_virtual_balance).to eq(30)
      end

      it 'is active' do
        expect(described_class.first.active).to eq(true)
      end

      it 'has account_id' do
        expect(described_class.first.account_id).to eq(user.account.id)
      end

      it 'has sku as product' do
        expect(described_class.first.sku).to eq(product.sku)
      end
    end
  end
end
