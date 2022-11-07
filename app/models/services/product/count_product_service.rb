module Services
  module Product
    class CountProductService < ApplicationService
      attr_reader :product, :product_command

      def initialize(product, product_command)
        @product = product
        @product_command = product_command
      end

      def call
        case product_command
        when 'purchase_product'
          @product.count_purchase_product
        when 'sale_product'
          @product.count_sale_product
        when 'balance_product'
          @product.balance
        else
          raise 'Not a product command'
        end
      end

      private

      def count_purchase_product
        from_store('LojaPrincipal').sum('Quantity')
      end

      def count_sale_product
        from_sale_store('LojaPrincipal').sum('Quantity')
      end

      def balance
        purchase_sale_balance = purchase_products.from_store('LojaPrincipal').sum('Quantity')
        purchase_sale_balance -= sale_products.from_sale_store('LojaPrincipal').sum('Quantity')
        purchase_sale_balance.to_s
      end
    end
  end
end
