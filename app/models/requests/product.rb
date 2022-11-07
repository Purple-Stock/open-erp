module Requests
  class Product
    attr_reader :page, :id

    def initialize(page: nil, id: nil)
      @page = page
      @id = id
    end

    def call
      make_request
    end

    private

    def make_resquest
      return HTTParty.get(uri_for_page, headers:) if page

      HTTParty.get(uri_for_id, headers:)
    end

    def base_uri
      Rails.configuration.management_api[:base_url]
    end

    def uri_for_page
      "#{base_uri}/ws/wsprodutos.json?page=#{page}"
    end

    def uri_for_id
      "#{base_uri}/ws/wsprodutos/#{id}.json"
    end

    def headers
      { content: 'application/json',
        Appkey: '' }
    end
  end
end
