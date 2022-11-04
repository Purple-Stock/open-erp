module Services
  module Sale
    class CountProductService < ApplicationService

      attr_reader :product_id, :product_command

      def initialize(product_id, product_command)
        @product = Product.find(product_id)
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
          raise "Not a product command"
        end
      end

      private

      def count_purchase_product
        # purchase_products.from_store('LojaPrincipal').sum('Quantity')
        from_store('LojaPrincipal').sum('Quantity')
      end

      def count_sale_product
        from_sale_store('LojaPrincipal').sum('Quantity')
        # sale_products.from_sale_store('LojaPrincipal').sum('Quantity')
      end

      def balance
        purchase_sale_balance = purchase_products.from_store('LojaPrincipal').sum('Quantity')
        purchase_sale_balance -= sale_products.from_sale_store('LojaPrincipal').sum('Quantity')
        purchase_sale_balance.to_s
      end
    end
  end
end