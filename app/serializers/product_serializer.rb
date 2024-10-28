# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id                               :bigint           not null, primary key
#  active                           :boolean
#  bar_code                         :string
#  extra_sku                        :string
#  highlight                        :boolean
#  name                             :string
#  number_of_pieces_per_fabric_roll :integer
#  price                            :float
#  sku                              :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  account_id                       :integer
#  bling_id                         :bigint
#  category_id                      :bigint
#  custom_id                        :integer
#  store_id                         :integer
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
class ProductSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :sku, :price, :active, :custom_id

  attribute :category do |object|
    object.category&.name
  end

  attribute :stock do |object|
    if object.stock
      object.stock.try(:quantity) || 0
    else
      0
    end
  end

  attribute :formatted_price do |object|
    ActionController::Base.helpers.number_to_currency(
      object.price,
      unit: "R$",
      separator: ",",
      delimiter: "."
    )
  end
end
