class BlingOrderItemHistoriesController < ApplicationController
  def index
    @bling_order_items = BlingOrderItem.all
  end
end
