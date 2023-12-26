require 'rails_helper'

RSpec.describe "productions/index", type: :view do
  before(:each) do
    assign(:productions, [
      Production.create!(
        quantity: 2
      ),
      Production.create!(
        quantity: 2
      )
    ])
  end

  it "renders a list of productions" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
  end
end
