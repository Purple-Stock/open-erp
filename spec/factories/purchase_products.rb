# frozen_string_literal: true

# == Schema Information
#
# Table name: purchase_products
#
#  id             :bigint           not null, primary key
#  quantity       :integer
#  store_entrance :integer          default("Sem_Loja")
#  value          :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  account_id     :integer
#  product_id     :bigint
#  purchase_id    :bigint
#
# Indexes
#
#  index_purchase_products_on_account_id   (account_id)
#  index_purchase_products_on_product_id   (product_id)
#  index_purchase_products_on_purchase_id  (purchase_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (purchase_id => purchases.id)
#
require_relative '../support/factory_helpers'

FactoryBot.define do
  factory :purchase_product do
    quantity { rand(1..10) }
    value { rand(1.0..100.00) }
    product_id { create(:product).id }
    store_entrance { 1 }

    account_id { create(:account).id }
  end
end
