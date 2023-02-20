require 'rails_helper'

RSpec.describe "stores/edit", type: :view do
  before(:each) do
    @store = assign(:store, Store.create!(
      name: "MyString",
      address: "MyString",
      phone: "MyString",
      email: "MyString",
      account_id: create(:account).id
    ))
  end

  it "renders the edit store form" do
    render

    assert_select "form[action=?][method=?]", store_path(@store), "post" do

      assert_select "input[name=?]", "store[name]"

      assert_select "input[name=?]", "store[address]"

      assert_select "input[name=?]", "store[phone]"

      assert_select "input[name=?]", "store[email]"
    end
  end
end
