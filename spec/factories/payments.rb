FactoryBot.define do
  factory :payment do
    amount { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    payment_date { Faker::Date.backward(days: 30) }
    association :production
  end
end