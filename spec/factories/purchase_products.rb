require_relative '../support/factory_helpers'

FactoryBot.define do
  factory :purchase_product do
    quantity { rand(1..10) }
    value { rand(1.0..100.00) }
    product_id { create(:product).id }
    store_entrance { 1 }

    account_id { create(:account).id }
  end
end
