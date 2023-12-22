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
    it { is_expected.to belong_to(:product).with_foreign_key(:bling_product_id) }
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
    let(:product) { FactoryBot.create(:product) }

    before { allow_any_instance_of(Product).to receive(:create_stock).and_return(true) }

    it 'is true' do
      stock = described_class.new
      stock.bling_product_id = product.id
      stock.total_balance = 30
      stock.total_virtual_balance = 30
      expect(stock.save).to be_truthy
    end
  end

  describe '#self.synchronize_bling' do
    let(:bling_product_id) { 16_181_499_539 }
    let(:product_ids) { [bling_product_id] }

    include_context 'with bling token'
    before do
      allow_any_instance_of(Product).to receive(:create_stock).and_return(true)
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

    context 'when attributes' do
      before do
        VCR.use_cassette('bling_stocks', erb: true) do
          described_class.synchronize_bling(user.account.id, product_ids)
        end
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
    end
  end
end
