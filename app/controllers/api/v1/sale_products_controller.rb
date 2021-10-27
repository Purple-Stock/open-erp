# frozen_string_literal: true

module Api
  module V1
    class SaleProductsController < ActionController::Base
      skip_before_action :verify_authenticity_token
      before_action :set_products, only: %i[remove_products]

      def remove_products
        save_succeeded = true
        @target_records = []
        sale = Sale.new(store_sale: params[:store_sale], account_id: @products[0][:account_id])
        if sale.save
          @products.each do |product|
            purchase_product = SaleProduct.new(product_id: product[:product_id], quantity: product[:quantity],
                                               account_id: product[:account_id], sale_id: sale.id)
            save_succeeded = false unless purchase_product.save
            @target_records << purchase_product
          end
          if save_succeeded
            render json: { status: 'success', message: 'Saved Sale Product', data: @target_records }, status: :ok
          else
            render json: { status: 'error', message: 'Sale Product not saved', data: @target_records },
                   status: :unprocessable_entity
          end
        end
      end

      private

      def set_products
        @products = params.require(:products)
      end
    end
  end
end
