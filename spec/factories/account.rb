# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    company_name { Faker::Company.name }

    user_id { create(:user).id }
  end
end
