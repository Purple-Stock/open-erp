module Requests
  class Order
    attr_reader :page, :id, :custom_uri

    def initialize(page: nil, id: nil, custom_uri: nil)
      @page = page
      @id = id
      @custom_uri = custom_uri
    end

    def call
      return custom_request if custom_uri

      make_request
    end

    private

    def make_resquest
      return HTTParty.get(uri_all_orders, headers: headers) if empty_params?
      return HTTParty.get(uri_for_page, headers: headers) if page

      HTTParty.get(uri_for_id, headers: headers)
    end

    def custom_request
      HTTParty.get(custom_uri, headers: headers)
    end

    def base_uri
      Rails.configuration.management_api[:base_url]
    end

    def uri_all_orders
      "#{base_uri}/wspedidos.json"
    end

    def uri_for_page
      "#{base_uri}/ws/wspedidos.json?page=#{page}"
    end

    def uri_for_id
      "#{base_uri}/ws/wspedidos/#{id}.json"
    end

    def headers
      { content: 'application/json',
        Appkey: '' }
    end

    def empty_params?
      page.nil? && id.nil?
    end
  end
end
