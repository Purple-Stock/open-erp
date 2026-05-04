# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'shared/_footer_auth.html.erb', type: :view do
  before { render }

  it 'exibe o nome da empresa' do
    expect(rendered).to include('Casa do Celular')
  end

  it 'aponta para o site institucional' do
    expect(rendered).to include('href="https://casadocelular.com.br"')
  end

  it 'inclui o ano corrente no copyright' do
    expect(rendered).to include(Date.today.year.to_s)
  end

  it 'não menciona mais Purple Stock / Open ERP' do
    expect(rendered).not_to match(/purple[\s\-_]?stock/i)
    expect(rendered).not_to match(/open\s?erp/i)
  end
end
