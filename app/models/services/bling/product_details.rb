# frozen_string_literal: true

module Services
  module Bling
    # Service::Bling::ProductDetails is used to get a single product's details from Bling API
    class ProductDetails < ApplicationService
      attr_accessor :product_id, :tenant

      def initialize(product_id:, tenant:)
        @product_id = product_id
        @tenant = tenant
      end

      def call
        find_product
      end

      private

      def find_product
        token = bling_token
        base_url = "https://www.bling.com.br/Api/v3/produtos/#{product_id}"

        headers = {
          'Accept' => 'application/json',
          'Authorization' => "Bearer #{token}"
        }

        response = HTTParty.get(base_url, headers:)

        if response['error'].present?
          sleep 10 if Rails.env.eql?('production') || Rails.env.eql?('staging')
          response = HTTParty.get(base_url, headers:)
        end

        if response['error'].present?
          sleep 10 if Rails.env.eql?('production') || Rails.env.eql?('staging')
          response = HTTParty.get(base_url, headers:)
        end

        raise(StandardError, response['error']['type']) if response['error'].present?

        JSON.parse(response.body)
      end

      def bling_token
        @bling_token ||= BlingDatum.find_by(account_id: @tenant).access_token
      end
    end
  end
end 