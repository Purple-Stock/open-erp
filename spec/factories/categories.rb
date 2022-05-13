FactoryBot.define do
  factory :category do
    name { FFaker::Internet.slug }

    account { create(:account) }
  end
end
