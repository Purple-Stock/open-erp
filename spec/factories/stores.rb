FactoryBot.define do
  factory :store do
    name { Faker::Company.name }
    address { Faker::Address.street_address }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    account_id { create(:account).id }
  end
end
