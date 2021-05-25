# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { FFaker::NameBR.first_name }
    last_name  { FFaker::NameBR.last_name }
    email { FFaker::Internet.email }
    company_name { FFaker::InternetSE.company_name_single_word }
    cpf_cnpj { FFaker::IdentificationBR.cnpj }
    phone { FFaker::PhoneNumber.phone_number }
    password { FFaker::Internet.password }
  end
end
