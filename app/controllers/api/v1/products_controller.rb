# frozen_string_literal: true

module Api
  module V1
    class ProductsController < ActionController::API
      include ActionController::MimeResponds
      set_current_tenant_through_filter
      before_action :set_tenant_from_qr_data

      def show_by_id
        begin
          @product = Product.find_by!(id: params[:id])
          render json: ProductSerializer.new(@product).serializable_hash
        rescue ActiveRecord::RecordNotFound => e
          Rails.logger.error "Product not found: #{e.message}"
          render json: { error: 'Product not found' }, status: :not_found
        rescue StandardError => e
          Rails.logger.error "Error in show_by_id: #{e.message}\n#{e.backtrace.join("\n")}"
          render json: { error: 'Internal server error' }, status: :internal_server_error
        end
      end

      def show
        @product = Product.find_by!(id: params[:id])
        render json: ProductSerializer.new(@product).serializable_hash
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: 'Product not found' }, status: :not_found
      end

      def show_product
        @product = Product.find(params[:id])
        render json: ProductSerializer.new(@product).serializable_hash
      end

      def index
        @products = Product.where(active: true)
        render json: ProductSerializer.new(@products).serializable_hash
      end

      def find_by_sku
        @product = Product.find_by!(sku: params[:sku])
        render json: ProductSerializer.new(@product).serializable_hash
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Product not found' }, status: :not_found
      end

      private

      def set_tenant_from_qr_data
        account_id = request.headers['X-Account-ID'] || params[:account_id]
        current_account = Account.find_by(id: account_id)
        set_current_tenant(current_account)
      end
    end
  end
end
