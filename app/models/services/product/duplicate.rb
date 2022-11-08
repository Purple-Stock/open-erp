# frozen_string_literal: true

module Services
  module Product
    class Duplicate < ApplicationService
      attr_reader :product

      def initialize(product)
        @product = product
      end

      def call
        product_clone = @product.dup
        product_clone.name = "#{product_clone.name} Cópia"
        product_clone.save
      end
    end
  end
end
