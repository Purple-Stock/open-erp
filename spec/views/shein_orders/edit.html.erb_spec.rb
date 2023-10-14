require 'rails_helper'

RSpec.describe "shein_orders/edit", type: :view do
  let(:shein_order) {
    SheinOrder.create!(
      data: ""
    )
  }

  before(:each) do
    assign(:shein_order, shein_order)
  end

  it "renders the edit shein_order form" do
    render

    assert_select "form[action=?][method=?]", shein_order_path(shein_order), "post" do

      assert_select "input[name=?]", "shein_order[data]"
    end
  end
end
