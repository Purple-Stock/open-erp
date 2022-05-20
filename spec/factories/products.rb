require_relative '../support/factory_helpers'

FactoryBot.define do
  factory :product do
    name { FFaker::Internet.slug }
    custom_id { rand(99999).to_s }
    sku { 'TESTESKU' }
    extra_sku { 'TESTESKU89' }
    image { FactoryHelpers.upload_file('spec/support/images/sem_imagem.jpeg', 'image/jpeg', true) }
    price { rand(100..400) }
    active { true }

    account { create(:account) }
    category { create(:category, account: account) }
  end
end
