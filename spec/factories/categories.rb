FactoryBot.define do
  factory :category do
    name { FFaker::Internet.slug }

    account_id { create(:account).id }
  end
end
