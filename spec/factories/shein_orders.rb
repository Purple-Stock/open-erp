# == Schema Information
#
# Table name: shein_orders
#
#  id         :bigint           not null, primary key
#  data       :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
# Indexes
#
#  index_shein_orders_on_account_id  (account_id)
#
FactoryBot.define do
  factory :shein_order do
    data { "" }
  end
end
