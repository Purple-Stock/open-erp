require 'rails_helper'

RSpec.describe "tailors/edit", type: :view do
  let(:tailor) {
    Tailor.create!(
      name: "MyString"
    )
  }

  before(:each) do
    assign(:tailor, tailor)
  end

  it "renders the edit tailor form" do
    render

    assert_select "form[action=?][method=?]", tailor_path(tailor), "post" do

      assert_select "input[name=?]", "tailor[name]"
    end
  end
end
