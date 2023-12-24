require 'rails_helper'

RSpec.describe "productions/edit", type: :view do
  let(:production) {
    Production.create!(
      quantity: 1
    )
  }

  before(:each) do
    assign(:production, production)
  end

  it "renders the edit production form" do
    render

    assert_select "form[action=?][method=?]", production_path(production), "post" do

      assert_select "input[name=?]", "production[quantity]"
    end
  end
end
