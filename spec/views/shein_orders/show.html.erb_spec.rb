require 'rails_helper'

RSpec.describe "shein_orders/show", type: :view do
  before(:each) do
    assign(:shein_order, SheinOrder.create!(
      data: ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
  end
end
