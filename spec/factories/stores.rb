# == Schema Information
#
# Table name: stores
#
#  id         :bigint           not null, primary key
#  address    :string
#  email      :string
#  name       :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
# Indexes
#
#  index_stores_on_account_id  (account_id)
#
FactoryBot.define do
  factory :store do
    name { Faker::Company.name }
    address { Faker::Address.street_address }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    account_id { create(:account).id }
  end
end
