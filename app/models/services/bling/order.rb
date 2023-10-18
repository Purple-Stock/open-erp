# frozen_string_literal: true

module Services
  module Bling
    class Order < ApplicationService
      attr_accessor :order_command, :tenant, :situation, :options

      def initialize(order_command:, tenant:, situation:, options: {})
        @order_command = order_command
        @tenant = tenant
        @situation = situation
        @options = options
      end

      def call
        case order_command
        when 'find_orders'
          find_orders
        else
          raise 'Not an order command'
        end
      end

      private

      def find_orders
        token = bling_token
        base_url = 'https://www.bling.com.br/Api/v3/pedidos/vendas'
        params = {
          limite: 100,
          idsSituacoes: [situation]
        }

        params.merge!(options)

        headers = {
          'Accept' => 'application/json',
          'Authorization' => "Bearer #{token}"
        }

        all_orders = []

        # Fetch data from the first two pages
        (1..).each do |page|
          response = HTTParty.get(base_url, query: params.merge(pagina: page), headers:)

          raise "Error: #{response.code} - #{response.message}" unless response.success?

          data = JSON.parse(response.body)
          break if data['data'].blank?

          all_orders.concat(data['data'])
        end

        { 'data' => all_orders }
      rescue StandardError => e
        { error: "Error: #{e.message}" }
      end

      def bling_token
        @bling_token ||= BlingDatum.find_by(account_id: @tenant).access_token
      end
    end
  end
end
