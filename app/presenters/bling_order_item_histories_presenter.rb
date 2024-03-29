# frozen_string_literal: true

# BlingOrderItemHistoriesPresentable returns the hash the Chart js needs.
class BlingOrderItemHistoriesPresenter
  attr_accessor :bling_order_item_collection

  def initialize(bling_order_item_collection)
    @bling_order_item_collection = bling_order_item_collection
  end

  def presentable
    bling_order_item_collection.group(:date).order(:date).count.map do |day_quantity|
      { day: day_quantity[0].strftime('%d/%m/%Y'), quantity: day_quantity[1] }
    end
  end
end
