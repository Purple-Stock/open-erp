# frozen_string_literal: true

module Services
  module Product
    class UpdateStatus < ApplicationService
      attr_reader :product

      def initialize(product)
        @product = product
      end

      def call    
        if @product.active.eql? true
          @product.update(active: false)
        else
          @product.update(active: true)
        end
      rescue StandardError
        errors.add(:active, message: 'não pode ser atualizado')
      end
    end
  end
end
