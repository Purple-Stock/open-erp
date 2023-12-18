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
class RevenueEstimation < ApplicationRecord
  attr_accessor :month

  validates :revenue, :average_ticket, :date, presence: :true
  validates :revenue, numericality: :true

  before_save :calculate_quantity
  before_validation :set_date

  scope :current_month, -> { where(date: Date.today.beginning_of_month...Date.today.end_of_month) }

  def daily_quantity
    number_of_days = Date.today.at_end_of_month.day
    quantity / number_of_days
  end

  private

  def calculate_quantity
    return unless valid_numeric_inputs?

    self.quantity = (revenue.to_f / average_ticket.to_f).to_i
  end

  def valid_numeric_inputs?
    revenue.is_a?(Numeric) && average_ticket.is_a?(Numeric) && average_ticket.to_f != 0
  end

  def set_date
    return if month.blank?

    year = Date.today.year
    day = Date.today.day
    self.date = Date.new(year, self.month.to_i, day)
  end
end
