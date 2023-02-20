# frozen_string_literal: true

json.extract! group_product, :id, :created_at, :updated_at
json.url group_product_url(group_product, format: :json)
