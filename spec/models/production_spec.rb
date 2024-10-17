# == Schema Information
#
# Table name: productions
#
#  id                     :bigint           not null, primary key
#  confirmed              :boolean
#  consider               :boolean          default(FALSE)
#  cut_date               :datetime
#  expected_delivery_date :date
#  fabric_cost            :decimal(10, 2)
#  notions_cost           :decimal(10, 2)
#  observation            :text
#  paid                   :boolean
#  payment_date           :date
#  pieces_missing         :integer
#  service_order_number   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  account_id             :integer
#  tailor_id              :bigint
#
# Indexes
#
#  index_productions_on_account_id              (account_id)
#  index_productions_on_confirmed               (confirmed)
#  index_productions_on_cut_date                (cut_date)
#  index_productions_on_expected_delivery_date  (expected_delivery_date)
#  index_productions_on_tailor_id               (tailor_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (tailor_id => tailors.id)
#
require 'rails_helper'

RSpec.describe Production, type: :model do
  describe 'associations' do
    it { should belong_to(:tailor) }
    it { should belong_to(:account) }
    it { should have_many(:production_products).dependent(:destroy) }
    it { should have_many(:products).through(:production_products) }
    it { should have_many(:payments).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:cut_date) }
    it { should validate_presence_of(:tailor) }
    it { should validate_presence_of(:account) }
    it { should validate_uniqueness_of(:service_order_number).scoped_to(:account_id) }
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for(:production_products).allow_destroy(true) }
    it { should accept_nested_attributes_for(:payments).allow_destroy(true) }
  end

  describe 'instance methods' do
    let(:account) { create(:account, :for_production_tests) }
    let(:production) do
      create(:production, :with_production_products,
             account: account,
             fabric_cost: 80,
             notions_cost: 20)
    end

    before do
      production.production_products.first.update(
        quantity: 10,
        unit_price: 10,
        pieces_delivered: 8, 
        dirty: 1, 
        error: 1
      )
      production.production_products.last.update(
        quantity: 5,
        unit_price: 10,
        pieces_delivered: 3, 
        discard: 2
      )
    end

    describe '#total_pieces_delivered' do
      it 'returns the sum of pieces delivered for all production products' do
        expect(production.total_pieces_delivered).to eq(11)
      end
    end

    describe '#total_missing_pieces' do
      it 'returns the sum of missing pieces for all production products' do
        expect(production.total_missing_pieces).to eq(0)
      end
    end

    describe '#total_dirty_pieces' do
      it 'returns the sum of dirty pieces for all production products' do
        expect(production.total_dirty_pieces).to eq(1)
      end
    end

    describe '#total_error_pieces' do
      it 'returns the sum of error pieces for all production products' do
        expect(production.total_error_pieces).to eq(1)
      end
    end

    describe '#total_discarded_pieces' do
      it 'returns the sum of discarded pieces for all production products' do
        expect(production.total_discarded_pieces).to eq(2)
      end
    end

    describe '#price_per_piece' do
      it 'calculates the price per piece correctly' do
        expect(production.price_per_piece).to be_within(0.01).of(6.67) # (80 + 20) / (10 + 5)
      end

      it 'returns 0 when total quantity is zero' do
        production.production_products.destroy_all
        expect(production.price_per_piece).to eq(0)
      end
    end

    describe '#total_price' do
      it 'calculates the total price correctly' do
        expect(production.total_price).to eq(150) # (10 * 10) + (5 * 10)
      end

      it 'excludes returned products from the total price' do
        production.production_products.last.update(returned: true)
        expect(production.total_price).to eq(100) # (10 * 10)
      end
    end

    describe '#total_paid' do
      it 'calculates the total paid amount correctly' do
        create(:payment, production: production, amount: 75)
        create(:payment, production: production, amount: 25)
        expect(production.total_paid).to eq(100)
      end
    end

    describe '#remaining_balance' do
      it 'calculates the remaining balance correctly' do
        create(:payment, production: production, amount: 75)
        expect(production.remaining_balance).to eq(75) # 150 - 75
      end

      it 'calculates the remaining balance correctly with returned products' do
        production.production_products.last.update(returned: true)
        create(:payment, production: production, amount: 75)
        expect(production.remaining_balance).to eq(25) # 100 - 75
      end
    end

    describe '#calendar_date' do
      it 'returns payment_date when confirmed' do
        production.update(confirmed: true, payment_date: Date.today + 7.days)
        expect(production.calendar_date).to eq(production.payment_date)
      end

      it 'returns expected_delivery_date when not confirmed' do
        production.update(confirmed: false, expected_delivery_date: Date.today + 14.days)
        expect(production.calendar_date).to eq(production.expected_delivery_date)
      end
    end

    describe '#total_value_delivered' do
      it 'calculates the total value of delivered pieces correctly' do
        production.production_products.first.update(
          pieces_delivered: 8,
          unit_price: 10
        )
        production.production_products.last.update(
          pieces_delivered: 3,
          unit_price: 15
        )

        expected_total = (8 * 10) + (3 * 15)
        expect(production.total_value_delivered).to eq(expected_total)
      end

      it 'returns 0 when no pieces have been delivered' do
        production.production_products.update_all(pieces_delivered: 0)
        expect(production.total_value_delivered).to eq(0)
      end

      it 'excludes non-delivered pieces from the calculation' do
        production.production_products.first.update(
          quantity: 10,
          pieces_delivered: 5,
          unit_price: 10
        )
        production.production_products.last.update(
          quantity: 8,
          pieces_delivered: 0,
          unit_price: 15
        )

        expect(production.total_value_delivered).to eq(50) # Only 5 * 10 for the first product
      end
    end
  end
end
