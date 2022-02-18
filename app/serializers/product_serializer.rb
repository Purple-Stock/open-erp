# frozen_string_literal: true

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
