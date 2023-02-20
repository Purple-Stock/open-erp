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
#  category_id :integer
#  custom_id   :integer
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
  include FastJsonapi::ObjectSerializer

  attributes :id, :custom_id, :name, :count_purchase_product, :count_sale_product, :active, :sku

  attribute :price do |object|
    "R$ #{object.price}"
  end

  attribute :balance, &:balance

  attribute :custom_id do |object|
    object.custom_id.to_i
  end

  attribute :category do |object|
    object.category.name
  end

  attribute :image_url do |object|
    object.image.attached? ? Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true) : 'https://purple-stock.s3-sa-east-1.amazonaws.com/images.png'
  end

  attribute :active do |object|
    if object.active
      'Sim'
    else
      'Não'
    end
  end
end
