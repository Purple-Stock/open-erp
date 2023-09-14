# frozen_string_literal: true

# == Schema Information
#
# Table name: customers
#
#  id         :bigint           not null, primary key
#  cellphone  :string
#  cpf        :string
#  email      :string
#  name       :string
#  phone      :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
# Indexes
#
#  index_customers_on_account_id  (account_id)
#  index_customers_on_slug        (slug) UNIQUE
#
require_relative '../support/factory_helpers'

FactoryBot.define do
  factory :customer do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { Faker::Number.number(digits: 10) }
    cellphone { Faker::Number.number(digits: 11) }
    cpf { Faker::Number.number(digits: 11) }

    account_id { create(:account).id }
  end
end
