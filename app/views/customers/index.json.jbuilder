# frozen_string_literal: true

json.array! @customers, partial: 'customers/customer', as: :customer
