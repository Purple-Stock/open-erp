# frozen_string_literal: true

json.array! @purchase_products, partial: 'purchase_products/purchase_product', as: :purchase_product
