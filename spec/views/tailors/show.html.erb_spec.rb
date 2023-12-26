require 'rails_helper'

RSpec.describe "tailors/show", type: :view do
  before(:each) do
    assign(:tailor, Tailor.create!(
      name: "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
