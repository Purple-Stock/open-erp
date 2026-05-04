# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'layouts/auth.html.erb', type: :view do
  before do
    allow(view).to receive(:platform).and_return(double(mobile_app?: false))
    render template: 'layouts/auth', layout: false
  end

  it 'exibe o nome Casa do Celular no <title>' do
    expect(rendered).to include('<title>Casa do Celular</title>')
  end

  it 'inclui o slogan oficial na meta description' do
    expect(rendered).to match(/<meta name="description" content="Casa do Celular — É barato e sempre será!"/)
  end

  it 'aponta o favicon para o asset cdc-favicon.png' do
    expect(rendered).to match(/<link rel="icon" type="image\/png" href="[^"]*cdc-favicon[^"]*"\/>/)
  end

  it 'usa a cor primária no theme-color' do
    expect(rendered).to include('content="#01297c"')
  end

  it 'não referencia mais Purple Stock' do
    expect(rendered).not_to match(/purple[\s\-_]?stock/i)
    expect(rendered).not_to include('purple-stock.s3-sa-east-1.amazonaws.com')
  end

  it 'renderiza o logo cdc-logo.png na área de login' do
    expect(rendered).to match(/<img[^>]+src="[^"]*cdc-logo[^"]*"/)
  end
end
