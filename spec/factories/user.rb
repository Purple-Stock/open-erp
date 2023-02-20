# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    company_name { Faker::Company.name }
    cpf_cnpj { Faker::Company.brazilian_company_number }
    phone { Faker::Number.number(digits: 10) }
    password { Faker::Internet.password }
  end
end
