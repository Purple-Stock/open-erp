# frozen_string_literal: true

json.extract! @product, :id, :name, :price, :bar_code, :highlight, :category_id, :active, :created_at, :updated_at
json.url product_url(@product, format: :json)
