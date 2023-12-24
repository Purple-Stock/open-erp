require 'rails_helper'

RSpec.describe "productions/new", type: :view do
  before(:each) do
    assign(:production, Production.new(
      quantity: 1
    ))
  end

  it "renders new production form" do
    render

    assert_select "form[action=?][method=?]", productions_path, "post" do

      assert_select "input[name=?]", "production[quantity]"
    end
  end
end
