FactoryBot.define do
  factory :products do
    name { FFaker::Internet.slug }
    association :account
  end
end
