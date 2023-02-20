FactoryBot.define do
  factory :store do
    name { "MyString" }
    address { "MyString" }
    phone { "MyString" }
    email { "MyString" }
    account_id { create(:account).id }
  end
end
