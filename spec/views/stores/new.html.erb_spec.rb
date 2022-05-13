require 'rails_helper'

RSpec.describe "stores/new", type: :view do
  before(:each) do
    assign(:store, Store.new(
      name: "MyString",
      address: "MyString",
      phone: "MyString",
      email: "MyString"
    ))
  end

  it "renders new store form" do
    render

    assert_select "form[action=?][method=?]", stores_path, "post" do

      assert_select "input[name=?]", "store[name]"

      assert_select "input[name=?]", "store[address]"

      assert_select "input[name=?]", "store[phone]"

      assert_select "input[name=?]", "store[email]"
    end
  end
end
