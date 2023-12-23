# frozen_string_literal: true

class StocksController < ApplicationController
  include Pagy::Backend
  inherit_resources

  protected

  def collection
    stocks = Stock.where(account_id: current_tenant)
    @pagy, @stocks = pagy(stocks)
  end
end
