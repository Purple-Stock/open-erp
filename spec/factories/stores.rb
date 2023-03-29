FactoryBot.define do
  factory :store do
    name { "My Store" }
    address { "123 Main St" }
    phone { "555-123-4567" }
    email { "store@example.com" }
    account_id { create(:account).id }

  end
end
