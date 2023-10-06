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
# RevenueEstimation exists to answer a question:
# How much Order Items to sale in order to achieve the average ticket
# for the given month?
class RevenueEstimation < ApplicationRecord
  attr_accessor :month

  validates :revenue, :quantity, :date, presence: :true
  validates :revenue, :quantity, numericality: :true

  before_save :calculate_average_ticket
  before_validation :set_date

  scope :current_month, -> { where(date: Date.today.beginning_of_month...Date.today.end_of_month) }

  private

  def calculate_average_ticket
    self.average_ticket = revenue / quantity
  end

  def set_date
    return if month.blank?

    year = Date.today.year
    day = Date.today.day
    self.date = Date.new(year, self.month.to_i, day)
  end
end
