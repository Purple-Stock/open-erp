require_relative '../support/factory_helpers'

FactoryBot.define do
  factory :customer do
    name { FFaker::Internet.slug }
    email { FFaker::Internet.email }
    phone { FFaker::PhoneNumber.phone_number }
    cpf { FFaker::IdentificationBR.cpf }

    account_id { create(:account).id }
  end
end
