require_relative '../support/factory_helpers'

FactoryBot.define do
  factory :purchase_product do
    quantity { 10 }
    value { 100.00 }
    product_id  { create(:product).id }
    store_entrance { 1 }
    
    account_id { create(:account).id }
  end
end
