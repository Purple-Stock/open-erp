# frozen_string_literal: true

module Services
  module Bling
    class FindOrder < ApplicationService
      attr_accessor :order_command

      def initialize(id:, order_command:)
        @id = id
        @order_command = order_command
      end

      def call
        case order_command
        when 'find_order'
          find_order
        else
          raise 'Not a order command'
        end
      end

      private

      def find_order
        url = URI("https://www.bling.com.br/Api/v3/pedidos/vendas/#{@id}")

        headers = {
          'Accept' => 'application/json',
          'Authorization' => "Bearer 61993e55431496330b14fcdd9b3bf4ca7b1ad9ef"
        }

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(url, headers)

        response = http.request(request)

        data = JSON.parse(response.read_body)

        data
      rescue StandardError => e
        "Error: #{e.message}"
      end
    end
  end
end
