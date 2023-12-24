require 'rails_helper'

RSpec.describe "productions/show", type: :view do
  before(:each) do
    assign(:production, Production.create!(
      quantity: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
  end
end
