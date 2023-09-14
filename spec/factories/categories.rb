# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
# Indexes
#
#  index_categories_on_account_id  (account_id)
#  index_categories_on_slug        (slug) UNIQUE
#
FactoryBot.define do
  factory :category do
    name { Faker::Lorem.word }

    account_id { create(:account).id }
  end
end
