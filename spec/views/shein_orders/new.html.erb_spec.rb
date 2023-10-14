require 'rails_helper'

RSpec.describe "shein_orders/new", type: :view do
  before(:each) do
    assign(:shein_order, SheinOrder.new(
      data: ""
    ))
  end

  it "renders new shein_order form" do
    render

    assert_select "form[action=?][method=?]", shein_orders_path, "post" do

      assert_select "input[name=?]", "shein_order[data]"
    end
  end
end
