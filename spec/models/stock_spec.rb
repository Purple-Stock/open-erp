# == Schema Information
#
# Table name: stocks
#
#  id                    :bigint           not null, primary key
#  total_balance         :integer
#  total_virtual_balance :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  bling_product_id      :bigint
#  product_id            :integer
#
require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe '#associations' do
    it { is_expected.to belong_to(:product) }
  end

  describe '#has column names' do
    it { is_expected.to have_db_column(:product_id) }
    it { is_expected.to have_db_column(:bling_product_id) }
    it { is_expected.to have_db_column(:total_balance) }
    it { is_expected.to have_db_column(:total_virtual_balance) }
  end

  describe '#validations' do
    it { is_expected.to validate_numericality_of(:product_id).only_integer }
    it { is_expected.to validate_numericality_of(:bling_product_id).only_integer }
    it { is_expected.to validate_numericality_of(:total_balance).only_integer }
    it { is_expected.to validate_numericality_of(:total_virtual_balance).only_integer }
  end

  describe '#self.synchronize_bling' do
    let(:bling_product_id) { 16_181_499_539 }
    let(:product) { FactoryBot.create(:product, bling_id: bling_product_id, account_id: user.account.id) }
    let(:product_ids) { [bling_product_id] }

    include_context 'with bling token'

    it 'creates stocks' do
      VCR.use_cassette('bling_stocks', erb: true) do
        expect do
          described_class.synchronize_bling(user.account.id, product_ids)
        end.to change(described_class, :count).by(1)
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

      it 'has total_balance' do
        expect(described_class.first.total_balance).to eq(30)
      end

      it 'has total_virtual_balance' do
        expect(described_class.first.total_virtual_balance).to eq(30)
      end

      it 'is active' do
        expect(described_class.first.active).to eq(true)
      end
    end
  end
end
