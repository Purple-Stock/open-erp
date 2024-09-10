# frozen_string_literal: true

module Services
  module Bling
    class Warehouses < ApplicationService
      attr_reader :tenant, :options

      def initialize(tenant:, options: {})
        @tenant = tenant
        @options = options
      end

      def call
        find_warehouses
      end

      private

      def find_warehouses
        token = bling_token
        base_url = 'https://www.bling.com.br/Api/v3/depositos'

        params = {
          pagina: options[:page] || 1,
          limite: options[:limit] || 100
        }

        params[:descricao] = options[:description] if options[:description]
        params[:situacao] = options[:status] if options[:status]

        headers = {
          'Accept' => 'application/json',
          'Authorization' => "Bearer #{token}"
        }

        response = HTTParty.get(base_url, query: params, headers: headers)

        if response.code == 200
          JSON.parse(response.body)
        else
          raise StandardError, "API error: #{response.code} - #{response.message}"
        end
      end

      def bling_token
        @bling_token ||= BlingDatum.find_by(account_id: @tenant).access_token
      end
    end
  end
end