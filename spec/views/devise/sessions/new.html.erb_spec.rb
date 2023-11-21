# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'devise/sessions/new.html.erb', type: :view do
  include Capybara::DSL

  context 'when sign in is successful' do
    let!(:user) { FactoryBot.create(:user) }

    it 'greet the user' do
      visit root_path

      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password

      click_button 'Entrar'

      expect(page).to have_content("Olá, #{user.email}")
    end
  end

  context 'when sign in fails' do
    it 'display error message' do
      visit root_path

      fill_in 'user_email', with: 'random@email.com'
      fill_in 'user_password', with: 'random_password'
      click_button 'Entrar'

      expect(page).to have_content('Email ou senha inválida.')
    end
  end
end
