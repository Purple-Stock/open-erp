# frozen_string_literal: true

class StocksController < ApplicationController
  require 'pagy/extras/array'
  include Pagy::ArrayExtra
  inherit_resources

  def index
    respond_to do |format|
      format.html { super }
      format.csv do
        @stocks_export = Stock.where(account_id: current_tenant)
        send_data @stocks_export.to_csv, file_name: 'stock_forecast.csv'
      end
    end
  end

  protected

  def collection
    @default_status_filter = params['status']
    @default_situation_balance_filter = params['balance_situation']

    stocks = Stock.where(account_id: current_tenant).includes([:product])
                  .only_positive_price(true)
                  .filter_by_status(params['status'])
                  .filter_by_total_balance_situation(params['balance_situation'])
                  .sort_by(&:calculate_basic_forecast)
                  .reverse!
    @pagy, @stocks = pagy_array(stocks)
  end
end
