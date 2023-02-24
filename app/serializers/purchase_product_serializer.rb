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
    "R$#{object.value.to_s.tr('.', ',')}"
  end

  attribute :image_url do |object|
    if object.product.image.attached?
      Rails.application.routes.url_helpers.rails_blob_path(object.product.image,
                                                           only_path: true)
    else
      'https://purple-stock.s3-sa-east-1.amazonaws.com/images.png'
    end
  end

  attribute :created_at do |object|
    object.created_at.strftime('%-d/%-m/%Y %H:%M')
  end
end
