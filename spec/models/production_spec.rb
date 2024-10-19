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
             fabric_cost: Faker::Number.decimal(l_digits: 2, r_digits: 2),
             notions_cost: Faker::Number.decimal(l_digits: 2, r_digits: 2))
    end

    before do
      production.production_products.first.update(
        quantity: Faker::Number.between(from: 5, to: 20),
        unit_price: Faker::Number.decimal(l_digits: 2, r_digits: 2),
        pieces_delivered: Faker::Number.between(from: 0, to: 15),
        dirty: Faker::Number.between(from: 0, to: 3),
        error: Faker::Number.between(from: 0, to: 3)
      )
      production.production_products.last.update(
        quantity: Faker::Number.between(from: 5, to: 20),
        unit_price: Faker::Number.decimal(l_digits: 2, r_digits: 2),
        pieces_delivered: Faker::Number.between(from: 0, to: 15),
        discard: Faker::Number.between(from: 0, to: 3)
      )
    end

    describe '#total_pieces_delivered' do
      it 'returns the sum of pieces delivered for all production products' do
        expected_total = production.production_products.sum(&:pieces_delivered)
        expect(production.total_pieces_delivered).to eq(expected_total)
      end
    end

    describe '#total_missing_pieces' do
      it 'returns the sum of missing pieces for all production products' do
        expected_missing = production.production_products.sum do |pp|
          next 0 if pp.returned
          pp.quantity - (pp.pieces_delivered + pp.dirty + pp.error + pp.discard)
        end
        expect(production.total_missing_pieces).to eq(expected_missing)
      end
    end

    describe '#total_dirty_pieces' do
      it 'returns the sum of dirty pieces for all production products' do
        expected_dirty = production.production_products.sum(&:dirty)
        expect(production.total_dirty_pieces).to eq(expected_dirty)
      end
    end

    describe '#total_error_pieces' do
      it 'returns the sum of error pieces for all production products' do
        expected_error = production.production_products.sum(&:error)
        expect(production.total_error_pieces).to eq(expected_error)
      end
    end

    describe '#total_discarded_pieces' do
      it 'returns the sum of discarded pieces for all production products' do
        expected_discarded = production.production_products.sum(&:discard)
        expect(production.total_discarded_pieces).to eq(expected_discarded)
      end
    end

    describe '#price_per_piece' do
      it 'calculates the price per piece correctly' do
        total_cost = production.fabric_cost + production.notions_cost
        total_quantity = production.production_products.sum(&:quantity)
        expected_price = total_quantity.zero? ? 0 : (total_cost / total_quantity)
        expect(production.price_per_piece).to be_within(0.01).of(expected_price)
      end

      it 'returns 0 when total quantity is zero' do
        production.production_products.update_all(quantity: 0)
        expect(production.price_per_piece).to eq(0)
      end
    end

    describe '#total_price' do
      it 'calculates the total price correctly' do
        expected_total = production.production_products.sum { |pp| pp.quantity * pp.unit_price }
        expect(production.total_price).to be_within(0.01).of(expected_total)
      end

      it 'excludes returned products from the total price' do
        production.production_products.last.update(returned: true)
        expected_total = production.production_products.sum do |pp|
          pp.returned ? 0 : pp.quantity * pp.unit_price
        end
        expect(production.total_price).to be_within(0.01).of(expected_total)
      end
    end

    describe '#total_paid' do
      it 'calculates the total paid amount correctly' do
        payment_amounts = [
          Faker::Number.decimal(l_digits: 2, r_digits: 2),
          Faker::Number.decimal(l_digits: 2, r_digits: 2)
        ]
        payment_amounts.each do |amount|
          create(:payment, production: production, amount: amount)
        end
        expect(production.total_paid).to be_within(0.01).of(payment_amounts.sum)
      end
    end

    describe '#remaining_balance' do
      it 'calculates the remaining balance correctly' do
        payment_amount = Faker::Number.decimal(l_digits: 2, r_digits: 2)
        create(:payment, production: production, amount: payment_amount)
        expected_balance = production.total_price - payment_amount
        expect(production.remaining_balance).to be_within(0.01).of(expected_balance)
      end
    end

    describe '#calendar_date' do
      it 'returns payment_date when confirmed' do
        payment_date = Faker::Date.forward(days: 30)
        production.update(confirmed: true, payment_date: payment_date)
        expect(production.calendar_date).to eq(payment_date)
      end

      it 'returns expected_delivery_date when not confirmed' do
        delivery_date = Faker::Date.forward(days: 30)
        production.update(confirmed: false, expected_delivery_date: delivery_date)
        expect(production.calendar_date).to eq(delivery_date)
      end
    end

    describe '#total_value_delivered' do
      it 'calculates the total value of delivered pieces correctly' do
        production.production_products.each do |pp|
          pp.update(
            pieces_delivered: Faker::Number.between(from: 0, to: 15),
            unit_price: Faker::Number.decimal(l_digits: 2, r_digits: 2)
          )
        end

        expected_total = production.production_products.sum { |pp| pp.pieces_delivered * pp.unit_price }
        expect(production.total_value_delivered).to be_within(0.01).of(expected_total)
      end

      it 'returns 0 when no pieces have been delivered' do
        production.production_products.update_all(pieces_delivered: 0)
        expect(production.total_value_delivered).to eq(0)
      end

      it 'excludes non-delivered pieces from the calculation' do
        production.production_products.first.update(
          quantity: Faker::Number.between(from: 10, to: 20),
          pieces_delivered: Faker::Number.between(from: 1, to: 9),
          unit_price: Faker::Number.decimal(l_digits: 2, r_digits: 2)
        )
        production.production_products.last.update(
          quantity: Faker::Number.between(from: 10, to: 20),
          pieces_delivered: 0,
          unit_price: Faker::Number.decimal(l_digits: 2, r_digits: 2)
        )

        expected_total = production.production_products.first.pieces_delivered * production.production_products.first.unit_price
        expect(production.total_value_delivered).to be_within(0.01).of(expected_total)
      end

      it 'handles nil unit_price correctly' do
        production.production_products.first.update(
          pieces_delivered: 5,
          unit_price: nil
        )
        production.production_products.last.update(
          pieces_delivered: 3,
          unit_price: 10.0
        )

        expected_total = 0 + (3 * 10.0)
        expect(production.total_value_delivered).to be_within(0.01).of(expected_total)
      end
    end
  end
end
