# frozen_string_literal: true

module Services
  module Bling
    # Service::Bling::Stock is used in the GoodJob service to get stocks from Bling API
    # Model Stock.synchronize_bling uses it to create/update itself according to bling stocks.
    class Stock < ApplicationService
      attr_accessor :stock_command, :tenant, :options

      def initialize(stock_command:, tenant:, options: {})
        @stock_command = stock_command
        @tenant = tenant
        @options = options
        options.delete(:max_pages)
      end

      def call
        case stock_command
        when 'find_stocks'
          find_stocks
        else
          raise 'Not a stock command'
        end
      end

      private

      def find_stocks
        token = bling_token
        base_url = 'https://www.bling.com.br/Api/v3/estoques/saldos'
        params = {}

        params.merge!(options)

        headers = {
          'Accept' => 'application/json',
          'Authorization' => "Bearer #{token}"
        }
        all_stocks = []
        response = HTTParty.get(base_url, query: params, headers:)

        raise(StandardError, response['error']['type']) if response['error'].present?

        data = JSON.parse(response.body)

        all_stocks.concat(data['data'])

        { 'data' => all_stocks }
      end

      def bling_token
        @bling_token ||= BlingDatum.find_by(account_id: @tenant).access_token
      end
    end
  end
end
