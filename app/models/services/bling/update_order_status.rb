# frozen_string_literal: true

module Services
  module Bling
    class UpdateOrderStatus < ApplicationService
      attr_accessor :tenant, :order_ids, :new_status

      def initialize(tenant:, order_ids:, new_status:)
        @tenant = tenant
        @order_ids = order_ids
        @new_status = new_status
      end

      def call
        token = bling_token
        base_url = 'https://www.bling.com.br/Api/v3'
        results = []
        
        order_ids.each do |order_id|
          url = "#{base_url}/pedidos/vendas/#{order_id}/situacoes/#{new_status}"
          response = HTTParty.patch(url, headers: authorization_headers(token))

          results << if response.success?
                       { order_id: order_id, status: 'success' }
                     else
                       { order_id: order_id, status: 'failed', error: response.message }
                     end
        end

        { results: results }
      rescue StandardError => e
        { error: "Error: #{e.message}" }
      end

      private

      def bling_token
        BlingDatum.find_by(account_id: tenant).access_token
      end

      def authorization_headers(token)
        {
          'Accept' => 'application/json',
          'Authorization' => "Bearer #{token}"
        }
      end
    end
  end
end
