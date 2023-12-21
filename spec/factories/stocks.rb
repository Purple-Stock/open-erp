# == Schema Information
#
# Table name: stocks
#
#  id                    :bigint           not null, primary key
#  total_balance         :integer
#  total_virtual_balance :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  account_id            :integer
#  bling_product_id      :bigint
#  product_id            :integer
#
FactoryBot.define do
  factory :stock do
    product_id { 1 }
    bling_product_id { 1 }
    total_balance { 1 }
    total_virtual_balance { 1 }
    account_id { 1 }
  end
end
