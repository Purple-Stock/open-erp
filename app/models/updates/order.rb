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
      HTTParty.put(uri_for_update, body: data, headers:)
    end

    def base_uri
      Rails.configuration.management_api[:base_url]
    end

    def uri_for_update
      "#{base_uri}/ws/wspedidos/#{id}.json"
    end

    def headers
      { content: 'application/json',
        Appkey: '' }
    end
  end
end
