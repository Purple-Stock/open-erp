# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  active      :boolean
#  bar_code    :string
#  extra_sku   :string
#  highlight   :boolean
#  name        :string
#  price       :float
#  sku         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :integer
#  category_id :bigint
#  custom_id   :integer
#  store_id    :integer
#
# Indexes
#
#  index_products_on_account_id   (account_id)
#  index_products_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
require_relative '../support/factory_helpers'

FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    custom_id { rand(99_999).to_s }
    sku { 'TESTESKU' }
    extra_sku { 'TESTESKU89' }
    image { FactoryHelpers.upload_file('spec/support/images/sem_imagem.jpeg', 'image/jpeg', true) }
    price { rand(100..400) }
    active { true }

    account_id { create(:account).id }
    category_id { create(:category, account_id:).id }
  end
end
