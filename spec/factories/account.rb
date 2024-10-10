# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    company_name { Faker::Company.name }
    user_id { create(:user).id }

    trait :for_production_tests do
      # Add any specific attributes or associations needed for production tests
      # For example:
      # has_many :productions
      # has_many :tailors
      # etc.
    end
  end
end
