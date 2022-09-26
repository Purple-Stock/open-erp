FactoryBot.define do
  factory :category do
    name { Faker::Lorem.word }

    account_id { create(:account).id }
  end
end
