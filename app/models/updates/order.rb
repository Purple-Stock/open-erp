module Updates
  class Order
    attr_reader :id, :data

    def initialize(id:, data:)
      @id = id
      @data = data
    end

    def call
      make_update
    end

    private

    def make_update
      HTTParty.put(uri_for_update, body: data, headers: headers)
    end

    def base_uri
      'https://purchasestore.com.br/'
    end

    def uri_for_update
      "#{base_uri}ws/wspedidos/#{id}.json"
    end

    def headers
      { content: 'application/json',
        Appkey: 'ZTgyYjMzZDJhMDVjMTVjZWM4OWNiMGU5NjI1NTNkYmU' }
    end
  end
end
