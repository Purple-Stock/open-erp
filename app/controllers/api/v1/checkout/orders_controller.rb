# frozen_string_literal: true

module Api
  module V1
    module Checkout
      class OrdersController < ApplicationController
        skip_before_action :authenticate_user!, only: [:find_order]

        def find_order
          @bling_shein_orders = BlingOrderItem
          .select('bling_order_items.*, shein_orders.data ->> \'Pacote do comerciante\' as pacote_do_comerciante, shein_orders.data ->> \'Número do pedido\' as numero_do_pedido, shein_orders.data ->> \'Status do produto\' as status_do_produto')
          .joins('LEFT JOIN shein_orders ON bling_order_items.marketplace_code_id = shein_orders.data->>\'Número do pedido\'')
          .where("shein_orders.data ->> 'Pacote do comerciante' = ?", params[:package_id])
          .where(account_id: params[:id])
          .first 
                  
          render json: { error: 'Not Found' }, status: :not_found if @bling_shein_orders.nil?          
        end
      end
    end
  end
end
