# frozen_string_literal: true

class StocksController < ApplicationController
  include Pagy::Backend
  inherit_resources

  protected

  def collection
    @default_status_filter = params['status']
    @default_situation_balance_filter = params['balance_situation']

    stocks = Stock.where(account_id: current_tenant)
                  .only_positive_price(true)
                  .filter_by_status(params['status'])
                  .filter_by_total_balance_situation(params['balance_situation'])
    @pagy, @stocks = pagy(stocks)
  end
end
