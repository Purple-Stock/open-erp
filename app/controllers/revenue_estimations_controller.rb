class RevenueEstimationsController < ApplicationController
  def index
    @revenue_estimations = RevenueEstimation.all
  end
end
