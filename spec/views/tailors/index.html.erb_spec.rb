require 'rails_helper'

RSpec.describe "tailors/index", type: :view do
  before(:each) do
    assign(:tailors, [
      Tailor.create!(
        name: "Name"
      ),
      Tailor.create!(
        name: "Name"
      )
    ])
  end

  it "renders a list of tailors" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
  end
end
