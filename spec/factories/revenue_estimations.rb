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
FactoryBot.define do
  factory :revenue_estimation do
    average_ticket { 9.99 }
    quantity { 1 }
    revenue { 9.99 }
    date { Date.today }
  end
end
