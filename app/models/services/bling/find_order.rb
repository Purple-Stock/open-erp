# frozen_string_literal: true

module Services
  module Bling
    class FindOrder < ApplicationService
      attr_accessor :id, :order_command, :tenant

      def initialize(id:, order_command:, tenant:)
        @id = id
        @order_command = order_command
        @tenant = tenant 
      end

      def call
        case order_command
        when 'find_order'
          find_order
        else
          { 'error' => { 'type' => 'INVALID_COMMAND', 'message' => 'Not a valid order command' } }
        end
      end

      private

      def find_order
        token = bling_token
        url = URI("https://www.bling.com.br/Api/v3/pedidos/vendas/#{@id}")

        headers = {
          'Accept' => 'application/json',
          'Authorization' => "Bearer #{token}"
        }

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(url, headers)

        response = http.request(request)

        parse_response(response)
      rescue StandardError => e
        { 'error' => { 'type' => 'REQUEST_ERROR', 'message' => e.message } }
      end

      def parse_response(response)
        body = JSON.parse(response.body)
        if response.is_a?(Net::HTTPSuccess)
          { 'data' => body }
        else
          { 'error' => { 'type' => 'API_ERROR', 'message' => body['message'] || 'Unknown error' } }
        end
      end

      def bling_token
        @bling_token ||= BlingDatum.find_by(account_id: tenant).access_token
      end
    end
  end
end
