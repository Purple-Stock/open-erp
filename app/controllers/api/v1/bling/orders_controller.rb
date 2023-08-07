# frozen_string_literal: true

module Api
  module V1
    module Bling
      class OrdersController < ApplicationController
        def show
          @orders = Services::Bling::Order.call(order_command: 'find_orders')
        end

        def get_token
          code = params[:code]
          client_id = ENV['CLIENT_ID']
          client_secret = ENV['CLIENT_SECRET']
          credentials = Base64.strict_encode64("#{client_id}:#{client_secret}")

          return render json: { error: 'Invalid code' }, status: :bad_request if code.blank?

          begin
            @response = HTTParty.post('https://bling.com.br/Api/v3/oauth/token',
                                      body: {
                                        grant_type: 'authorization_code',
                                        code:
                                      },
                                      headers: {
                                        'Content-Type' => 'application/x-www-form-urlencoded',
                                        'Accept' => '1.0',
                                        'Authorization' => "Basic #{credentials}"
                                      })
            verify_tokens
            render json: @response.parsed_response
          rescue StandardError => e
            render json: { error: e.message }, status: :internal_server_error
          end
        end

        private

        def verify_tokens
          tokens = BlingDatum.find_by(account_id: current_tenant.id)
          if tokens.nil?
            BlingDatum.create(access_token: @response['access_token'],
                              expires_in: @response['expires_in'],
                              expires_at: Time.zone.now + @response['expires_in'].seconds,
                              token_type: @response['token_type'],
                              scope: @response['scope'],
                              refresh_token: @response['refresh_token'],
                              account_id: current_tenant.id)
          else
            tokens.update(access_token: @response['access_token'],
                          expires_in: @response['expires_in'],
                          expires_at: Time.zone.now + @response['expires_in'].seconds,
                          token_type: @response['token_type'],
                          scope: @response['scope'],
                          refresh_token: @response['refresh_token'])
          end
        end
      end
    end
  end
end
