# frozen_string_literal: true

json.extract! purchase_product, :id, :quantity, :value, :product_id, :purchaseId, :created_at, :updated_at
json.url purchase_product_url(purchase_product, format: :json)
