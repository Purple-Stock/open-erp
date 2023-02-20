# frozen_string_literal: true

json.array! @products, partial: 'api/v1/products/product', as: :product
