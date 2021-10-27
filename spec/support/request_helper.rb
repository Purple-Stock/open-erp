module RequestHelper
  def body_json(symbolize_key: false)
    json = JSON.parse(response.body)
    symbolize_key ? json.symbolize_keys : json
  rescue
    return {}
  end
end

RSpec.configure do |config|
  config.include RequestHelper, type: :request
end
