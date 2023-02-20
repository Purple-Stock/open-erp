require_relative '../support/factory_helpers'

FactoryBot.define do
  factory :sale_product do
    quantity { Faker::Number.between(1, 100) }
    value { Faker::Commerce.price }
    created_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    updated_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    account_id { Faker::Number.between(1, 100) }
    product_id { Faker::Number.between(1, 100) }
    sale_id { create(:sale).id }
  end
end