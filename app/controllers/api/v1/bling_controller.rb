module Api
  module V1
    class BlingController < ApplicationController
      def update_stock
        warehouse_id = params[:warehouse_id].presence || 
                      Warehouse.find_by(account_id: current_tenant, is_default: true)&.bling_id ||
                      Warehouse.first&.bling_id

        result = Services::Bling::CreateStockRecord.call(
          warehouse_id: warehouse_id,
          product_id: params[:product_id],
          quantity: params[:quantity],
          operation: params[:operation],
          notes: params[:notes],
          tenant: current_tenant
        )

        if result.success?
          render json: { success: true, data: result.data }
        else
          render json: { success: false, error: result.error }, status: :unprocessable_entity
        end
      end

      private

      def warehouse_not_found
        render json: { 
          success: false, 
          error: "No warehouse found for this account" 
        }, status: :unprocessable_entity
      end
    end
  end
end 