FactoryBot.define do
  factory :category do
    name { FFaker::Internet.slug }
    association :account
  end
end
