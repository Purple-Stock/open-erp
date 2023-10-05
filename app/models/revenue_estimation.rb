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
  validates :revenue, :quantity, :date, presence: :true

  before_save :calculate_average_ticket

  private

  def calculate_average_ticket
    self.average_ticket = revenue / quantity
  end
end
