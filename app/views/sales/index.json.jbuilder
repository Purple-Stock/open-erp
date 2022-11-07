# frozen_string_literal: true

json.array! @sales, partial: 'sales/sale', as: :sale
