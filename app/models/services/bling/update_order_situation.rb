# frozen_string_literal: true

module Services
  module Bling
    class UpdateOrderSituation < ApplicationService
      attr_accessor :id, :tenant, :new_situation_id

      def initialize(id:, tenant:, new_situation_id:)
        @id = id
        @tenant = tenant
        @new_situation_id = new_situation_id
      end

      def call
        update_order_situation
      end

      private

      def update_order_situation
        token = bling_token
        url = URI("https://www.bling.com.br/Api/v3/pedidos/vendas/#{@id}")

        headers = {
          'Accept' => 'application/json',
          'Authorization' => "Bearer #{token}",
          'Content-Type' => 'application/json'
        }

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        body_hash = {
          'situacao' => {
            'id' => @new_situacao_id
          }
        }

        body_json = body_hash.to_json

        request = Net::HTTP::Put.new(url, headers)
        request.body = body_json

        response = http.request(request)

        JSON.parse(response.read_body)
      rescue StandardError => e
        "Error: #{e.message}"
      end

      def bling_token
        BlingDatum.find_by(account_id: tenant).access_token
      end
    end
  end
end
