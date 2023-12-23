# frozen_string_literal: true

require 'spec_helper'

shared_context 'when skip create_stock callback' do
  before do
    Product.skip_callback(:create, :after, :create_stock)
  end

  after do
    Product.set_callback(:create, :after, :create_stock)
  end
end

shared_context 'with product' do
  let(:product) { FactoryBot.create(:product) }
end
