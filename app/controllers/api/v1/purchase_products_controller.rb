# frozen_string_literal: true

module Api
  module V1
    class PurchaseProductsController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :set_products, only: %i[add_products add_inventory_quantity]

      def add_products
        save_succeeded = true
        @target_records = []
        @products.each do |product|
          purchase_product = PurchaseProduct.new(product_id: product[:product_id], quantity: product[:quantity],
                                                 store_entrance: params[:store_entrance], account_id: product[:account_id])
          save_succeeded = false unless purchase_product.save
          @target_records << purchase_product
        end
        if save_succeeded
          render json: { status: 'success', message: 'Saved Purchase Product', data: @target_records }, status: :ok
        else
          render json: { status: 'error', message: 'Purchase Product not saved', data: @target_records },
                 status: :unprocessable_entity
        end
      end

      def add_inventory_quantity
        save_succeeded = true
        @target_records = []
        purchase_store = 'LojaSecundaria'
        purchase_store = 'LojaPrincipal' if params[:store_entrance] == 1
        @products.each do |product|
          product_found = Product.find(product[:product_id])
          purchase_product = product_found.purchase_products.from_store(purchase_store).sum('Quantity')
          sale_products = product_found.sale_products.from_sale_store(purchase_store).sum('Quantity')
          balance = purchase_product - sale_products
          purchase_quantity = product[:quantity] - balance
          begin
            purchase_product = PurchaseProduct.new(product_id: product[:product_id], quantity: purchase_quantity,
                                                   store_entrance: params[:store_entrance], account_id: product[:account_id])
            save_succeeded = false unless purchase_product.save
            @target_records << purchase_product
          rescue ArgumentError
            Rails.logger.debug 'erro'
          end
        end
        if save_succeeded
          render json: { status: 'success', message: 'Saved Purchase Product', data: @target_records }, status: :ok
        else
          render json: { status: 'error', message: 'Purchase Product not saved', data: @target_records },
                 status: :unprocessable_entity
        end
      end

      private

      def set_products
        @products = params.require(:products)
      end
    end
  end
end
