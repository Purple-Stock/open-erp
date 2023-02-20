# frozen_string_literal: true

module Api
  module V1
    class ProductsController < ApplicationController
      def show
        @product = Product.find_by(custom_id: params[:custom_id])
      end

      def show_product
        @product = Product.find(params[:id])
      end

      def index
        @products = Product.where(active: true)
      end
    end
  end
end
