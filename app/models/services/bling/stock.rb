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
        
        Rails.logger.info "Sending request to Bling API: #{base_url} with params: #{params}"
        response = HTTParty.get(base_url, query: params, headers:)
        Rails.logger.info "Bling API response code: #{response.code}"
        Rails.logger.info "Bling API response body: #{response.body}"

        if response.code != 200
          error_message = "Bling API Error: HTTP #{response.code} - #{response.body}"
          raise StandardError, error_message
        end

        data = JSON.parse(response.body)

        if data['error'].present?
          error_message = "Bling API Error: #{data['error']['type']} - #{data['error']['message']}"
          raise StandardError, error_message
        end

        all_stocks.concat(data['data'])

        { 'data' => all_stocks }
      end

      def bling_token
        @bling_token ||= BlingDatum.find_by(account_id: @tenant).access_token
      end
    end
  end
end
