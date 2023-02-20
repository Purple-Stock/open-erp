require 'rails_helper'

RSpec.describe "stores/index", type: :view do
  before(:each) do
    assign(:stores, [
      Store.create!(
        name: "Name",
        address: "Address",
        phone: "Phone",
        email: "Email",
        account: create(:account)
      ),
      Store.create!(
        name: "Name",
        address: "Address",
        phone: "Phone",
        email: "Email",
        account: create(:account)
      )
    ])
  end

  xit "renders a list of stores" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "Address".to_s, count: 2
    assert_select "tr>td", text: "Phone".to_s, count: 2
    assert_select "tr>td", text: "Email".to_s, count: 2
    assert_select "tr>td", text: create(:account).name.to_s, count: 2
  end
end
