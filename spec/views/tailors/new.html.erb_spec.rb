require 'rails_helper'

RSpec.describe "tailors/new", type: :view do
  before(:each) do
    assign(:tailor, Tailor.new(
      name: "MyString"
    ))
  end

  it "renders new tailor form" do
    render

    assert_select "form[action=?][method=?]", tailors_path, "post" do

      assert_select "input[name=?]", "tailor[name]"
    end
  end
end
