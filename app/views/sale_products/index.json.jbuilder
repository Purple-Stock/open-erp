# frozen_string_literal: true

json.array! @sale_products, partial: 'sale_products/sale_product', as: :sale_product
