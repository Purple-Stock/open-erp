require_relative '../support/factory_helpers'

FactoryBot.define do
  factory :sale do
    value { rand(100..400) }
    online { [true, false].sample }
    customer_id { create(:customer).id }
    payment_type { rand(0..6) }
    # store_sale
    total_exchange_value { rand(100..400) }

    account_id { create(:account).id }
  end
end
