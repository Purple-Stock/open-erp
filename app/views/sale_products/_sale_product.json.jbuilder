# frozen_string_literal: true

json.extract! sale_product, :id, :quantity, :value, :product_id, :saleId, :created_at, :updated_at
json.url sale_product_url(sale_product, format: :json)
