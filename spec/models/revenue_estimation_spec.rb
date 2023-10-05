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

  describe '#avarage_ticket' do
    it 'is 20' do
      subject.quantity = 5
      subject.revenue = 100.0
      subject.date = Date.new(2023, 10)
      subject.save
      expect(subject.average_ticket).to eq(20.0)
    end
  end
end
