require_relative '../support/factory_helpers'

FactoryBot.define do
  factory :customer do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    cpf { Faker::Number.number(digits: 11) }

    account_id { create(:account).id }
  end
end
