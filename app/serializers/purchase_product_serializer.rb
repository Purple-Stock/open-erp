class PurchaseProductSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :quantity

  attribute :name do |object|
    object.product.name
  end  

  attribute :custom_id do |object|
    object.product.custom_id
  end

  attribute :value do |object|
    "R$#{object.value.to_s.gsub('.', ',')}"
  end  

  attribute :image_url do |object|
    object.product.image.attached? ? Rails.application.routes.url_helpers.rails_blob_path(object.product.image, only_path: true) : "https://purple-stock.s3-sa-east-1.amazonaws.com/images.png"
  end  

  attribute :created_at do |object|
    object.created_at.strftime("%-d/%-m/%Y %H:%M")
  end

end
