module Requests
  class Order
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
      return HTTParty.get(uri_all_orders, headers: headers) if empty_params?
      return HTTParty.get(uri_for_page, headers: headers) if page

      HTTParty.get(uri_for_id, headers: headers)
    end

    def base_uri
      'https://purchasestore.com.br/'
    end

    def uri_all_orders
      "#{base_uri}wspedidos.json"
    end

    def uri_for_page
      "#{base_uri}ws/wspedidos.json?page=#{page}"
    end

    def uri_for_id
      "#{base_uri}ws/wspedidos/#{id}.json"
    end

    def headers
      { content: 'application/json',
        Appkey: 'ZTgyYjMzZDJhMDVjMTVjZWM4OWNiMGU5NjI1NTNkYmU' }
    end

    def empty_params?
      page.nil? && id.nil?
    end
  end
end
