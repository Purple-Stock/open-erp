# frozen_string_literal: true

json.array! @products, partial: 'products/product', as: :product
