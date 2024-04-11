# frozen_string_literal: true

require 'spec_helper'

shared_context 'with user signed in' do
  let(:user) { FactoryBot.create(:user) }

  before { sign_in user }
end
