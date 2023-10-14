require 'rails_helper'

RSpec.describe "shein_orders/index", type: :view do
  before(:each) do
    assign(:shein_orders, [
      SheinOrder.create!(
        data: ""
      ),
      SheinOrder.create!(
        data: ""
      )
    ])
  end

  it "renders a list of shein_orders" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
  end
end
