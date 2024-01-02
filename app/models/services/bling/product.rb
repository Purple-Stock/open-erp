# frozen_string_literal: true

module Services
  module Bling
    # Service::Bling::Product is used in the GoodJob service to get products from Bling API
    # Model Product.synchronize_bling uses it to create/update itself according to bling products.
    class Product < ApplicationService
      attr_accessor :product_command, :tenant, :options

      def initialize(product_command:, tenant:, options: {})
        @product_command = product_command
        @tenant = tenant
        @options = options
        @max_pages = options[:max_pages]
        options.delete(:max_pages)
      end

      def call
        case product_command
        when 'find_products'
          find_products
        else
          raise 'Not a product command'
        end
      end

      private

      def find_products
        token = bling_token
        base_url = 'https://www.bling.com.br/Api/v3/produtos'
        params = {
          limite: 100
        }

        params.merge!(options)

        headers = {
          'Accept' => 'application/json',
          'Authorization' => "Bearer #{token}"
        }

        all_products = []

        (1..@max_pages).each do |page|
          # we do not need to request all massive data. If the first page works, so does the remaining pages.
          break if (page.eql?(2) && Rails.env.eql?('test'))

          response = HTTParty.get(base_url, query: params.merge(pagina: page), headers:)
          if response['error'].present?
            sleep 10
            response = HTTParty.get(base_url, query: params.merge(pagina: page), headers:)
          end

          raise(StandardError, response['error']['type']) if response['error'].present?

          data = JSON.parse(response.body)
          break if data['data'].blank?

          all_products.concat(data['data'])
        end

        { 'data' => all_products }
      end

      def bling_token
        @bling_token ||= BlingDatum.find_by(account_id: @tenant).access_token
      end
    end
  end
end
