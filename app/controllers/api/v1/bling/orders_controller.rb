# frozen_string_literal: true

module Api
  module V1
    module Bling
      class OrdersController < ApplicationController
        def show
          @orders = Services.Bling.Order.call(order_command: 'find_orders')
        end
      end
    end
  end
end
