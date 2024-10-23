# frozen_string_literal: true

module Services
  module Bling
    class FetchModules < ApplicationService
      attr_accessor :tenant

      def initialize(tenant:)
        @tenant = tenant
      end

      def call
        fetch_modules
      end

      private

      def fetch_modules
        token = bling_token
        url = URI("https://www.bling.com.br/Api/v3/situacoes/modulos")

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
          { 'data' => body['data'] }
        else
          { 'error' => { 'type' => 'API_ERROR', 'message' => body || 'Unknown error' } }
        end
      end

      def bling_token
        @bling_token ||= BlingDatum.find_by(account_id: tenant).access_token
      end
    end
  end
end
