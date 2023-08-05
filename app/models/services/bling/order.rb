# frozen_string_literal: true

module Services
  module Bling
    class Order < ApplicationService
      attr_accessor :product, :order_command

      def initialize(order_command:)
        @product_command = order_command
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
        url = URI('https://www.bling.com.br/Api/v3/pedidos/vendas')
        params = {
          pagina: 1,
          limite: 100,
          idsSituacoes: [15]
        }

        headers = {
          'Accept' => 'application/json',
          'Authorization' => "Bearer #{ENV['KEY']}"
        }

        url.query = URI.encode_www_form(params)

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(url, headers)

        response = http.request(request)

        data = JSON.parse(response.read_body)

        puts data
      rescue StandardError => e
        puts "Error: #{e.message}"
      end
    end
  end
end
