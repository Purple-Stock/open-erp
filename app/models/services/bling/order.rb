# frozen_string_literal: true

module Services
  module Bling
    class Order < ApplicationService
      attr_accessor :order_command, :tenant

      def initialize(order_command:, tenant:)
        @order_command = order_command
        @tenant = tenant
      end

      def call
        case order_command
        when 'find_orders'
          find_orders
        else
          raise 'Not a order command'
        end
      end

      private

      def find_orders
        token = bling_token
        url = URI('https://www.bling.com.br/Api/v3/pedidos/vendas')
        params = {
          pagina: 1,
          limite: 100,
          idsSituacoes: [15]
        }

        headers = {
          'Accept' => 'application/json',
          'Authorization' => "Bearer #{token}"
        }

        url.query = URI.encode_www_form(params)

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(url, headers)

        response = http.request(request)

        data = JSON.parse(response.read_body)

        data
      rescue StandardError => e
        "Error: #{e.message}"
      end

      def bling_token
        BlingDatum.find_by(account_id: @tenant).access_token
      end
    end
  end
end
