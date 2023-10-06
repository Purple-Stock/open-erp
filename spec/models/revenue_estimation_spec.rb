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
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_presence_of(:date) }
  end

  describe '#save' do
    context 'valid' do
      before do
        allow(Date).to receive(:today).and_return Date.new(2022, 10, 3)
        subject.quantity = 5
        subject.revenue = 100.0
        subject.month = 10
        subject.save
      end

      it 'is 20' do
        expect(subject.average_ticket).to eq(20.0)
      end

      it 'has date year' do
        expect(subject.date.year).to eq(2022)
      end

      it 'has month' do
        expect(subject.date.month).to eq(10)
      end
    end
  end
end
