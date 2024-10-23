# frozen_string_literal: true

module Services
  module Bling
    class FetchModuleSituations < ApplicationService
      attr_accessor :tenant, :module_id

      def initialize(tenant:, module_id:)
        @tenant = tenant
        @module_id = module_id
      end

      def call
        fetch_and_save_module_situations
      end

      private

      def fetch_and_save_module_situations
        response = fetch_module_situations
        return response if response['error']

        save_module_situations(response['data'])
        response
      end

      def fetch_module_situations
        token = bling_token
        url = URI("https://www.bling.com.br/Api/v3/situacoes/modulos/#{@module_id}")

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

      def save_module_situations(situations)
        situations.each do |situation|
          BlingModuleSituation.find_or_initialize_by(situation_id: situation['id']).tap do |s|
            s.name = situation['nome']
            s.inherited_id = situation['idHerdado']
            s.color = situation['cor']
            s.module_id = @module_id
            s.save!
          end
        end
      end

      def bling_token
        @bling_token ||= BlingDatum.find_by(account_id: tenant).access_token
      end
    end
  end
end
