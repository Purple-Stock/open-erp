# == Schema Information
#
# Table name: finance_data
#
#  id           :bigint           not null, primary key
#  date         :date
#  expense      :decimal(, )
#  fixed_amount :decimal(, )
#  income       :decimal(, )
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class FinanceDatum < ApplicationRecord
end
