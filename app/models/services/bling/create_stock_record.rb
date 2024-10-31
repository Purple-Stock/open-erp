# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

module Services
  module Bling
    class CreateStockRecord < ApplicationService
      VALID_OPERATIONS = {
        'B' => 'balanço',
        'E' => 'entrada',
        'S' => 'saída'
      }.freeze

      attr_reader :warehouse_id, :product_id, :quantity, :operation, :price, :cost, :notes, :tenant

      def initialize(warehouse_id:, product_id:, quantity:, operation:, tenant:, price: nil, cost: nil, notes: nil)
        @warehouse_id = warehouse_id
        @product_id = product_id
        @quantity = quantity
        @operation = operation.to_s.upcase
        @price = price
        @cost = cost
        @notes = notes
        @tenant = tenant
      end

      def call
        return missing_warehouse_error if warehouse_id.nil?
        return invalid_operation_error unless valid_operation?

        url = URI("https://www.bling.com.br/Api/v3/estoques")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Post.new(url)
        request["Accept"] = "application/json"
        request["Content-Type"] = "application/json"
        request["Authorization"] = "Bearer #{bling_token}"
        print('payload_tetas')
        print(build_payload.to_json)
        request.body = build_payload.to_json

        response = http.request(request)
        handle_response(response)
      rescue StandardError => e
        Rails.logger.error "Bling API Error: #{e.message}"
        OpenStruct.new(success?: false, error: e.message)
      end

      private

      def valid_operation?
        VALID_OPERATIONS.key?(@operation)
      end

      def invalid_operation_error
        OpenStruct.new(
          success?: false,
          error: "Invalid operation. Accepted values: B (#{VALID_OPERATIONS['B']}), " \
                "E (#{VALID_OPERATIONS['E']}), S (#{VALID_OPERATIONS['S']})"
        )
      end

      def missing_warehouse_error
        OpenStruct.new(
          success?: false,
          error: "No warehouse found. Please set up a warehouse first."
        )
      end

      def build_payload
        {
          deposito: {
            id: warehouse_id
          },
          operacao: operation,
          produto: {
            id: product_id
          },
          quantidade: quantity.to_f,
          preco: price&.to_f,
          custo: cost&.to_f,
          observacoes: notes
        }.compact
      end

      def bling_token
        @bling_token ||= BlingDatum.find_by(account_id: tenant).access_token
      end

      def handle_response(response)
        case response.code.to_i
        when 201, 200
          OpenStruct.new(
            success?: true,
            data: JSON.parse(response.body)
          )
        else
          OpenStruct.new(
            success?: false,
            error: "API Error: #{response.code} - #{response.body}"
          )
        end
      end
    end
  end
end 