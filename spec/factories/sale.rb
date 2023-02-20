# frozen_string_literal: true

require_relative '../support/factory_helpers'

FactoryBot.define do
  factory :sale do
    store_sale { 0 }
    created_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    updated_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
    account_id { create(:account).id }
    disclosure { Faker::Lorem.paragraph }
    discount { Faker::Commerce.price }
    exchange { Faker::Commerce.price }
    online { Faker::Boolean.boolean }
    payment_type { 0 }
    percentage { Faker::Commerce.price }
    total_exchange_value { Faker::Commerce.price }
    value { Faker::Commerce.price }
    customer_id { create(:customer).id }
  end
end
