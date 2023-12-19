# frozen_string_literal: true

# == Schema Information
#
# Table name: revenue_estimations
#
#  id             :bigint           not null, primary key
#  average_ticket :decimal(, )
#  date           :date
#  quantity       :integer
#  revenue        :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require 'rails_helper'

RSpec.describe RevenueEstimation, type: :model do
  describe '#validations' do
    it { is_expected.to validate_presence_of(:revenue) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_numericality_of(:revenue) }
    it { is_expected.to validate_numericality_of(:average_ticket).is_greater_than(0) }
  end

  describe '#save' do
    context 'valid' do
      before do
        allow(Date).to receive(:today).and_return Date.new(2022, 10, 3)
        subject.revenue = 1000.0
        subject.average_ticket = 10
        subject.month = 10
        subject.save
      end

      it 'calculates quantity based on average ticket and revenue estimated' do
        expect(subject.quantity).to eq(100)
      end

      it 'has daily_quantity' do
        expect(subject.daily_quantity).to eq(3)
      end

      it 'has date year' do
        expect(subject.date.year).to eq(2022)
      end

      it 'has month' do
        expect(subject.date.month).to eq(10)
      end
    end
  end

  describe '#calculate_quantity' do
    context 'with valid inputs' do
      it 'calculates quantity based on revenue and average_ticket' do
        revenue_estimation = create(:revenue_estimation, revenue: 1000, average_ticket: 50)
        expect(revenue_estimation.quantity).to eq(20)
      end
    end

    context 'with invalid inputs' do
      it 'handles when revenue or average_ticket is a string' do
        revenue_estimation = build(:revenue_estimation, revenue: 'invalid', average_ticket: 'invalid')
        expect(revenue_estimation).not_to be_valid
      end

      it 'handles zero average_ticket' do
        revenue_estimation = build(:revenue_estimation, revenue: 50, average_ticket: 0)
        expect(revenue_estimation).not_to be_valid
      end
    end
  end
end
