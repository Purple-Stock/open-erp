# frozen_string_literal: true

json.array! @categories, partial: 'categories/category', as: :category
