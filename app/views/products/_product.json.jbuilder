json.extract! product, :id, :name, :price, :bar_code, :image_url, :highlight, :count_purchase_product, :count_sale_product, :category_id, :active, :created_at, :updated_at
json.product_balance product.count_purchase_product.to_i - product.count_sale_product.to_i
json.url product_url(product, format: :json)
