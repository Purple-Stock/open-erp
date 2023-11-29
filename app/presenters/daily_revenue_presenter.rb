# frozen_string_literal: true

# DailyRevenuePresenter returns the hash the Chart js needs.
# From the Char.js doc, https://www.chartjs.org/docs/latest/general/data-structures.html#parsing
class DailyRevenuePresenter
  attr_accessor :bling_order_item_collection, :filter

  def initialize(bling_order_item_collection, filter = nil)
    @bling_order_item_collection = bling_order_item_collection
    @filter = filter || Date.today
  end

  def presentable
    zeros_datasets = [{ x: filter.strftime('%d/%m/%Y'), shein: 0.0, shopee: 0.0, simple_7: 0.0, mercado_livre: 0.0 }]
    return zeros_datasets if bling_order_item_collection.blank?
  end
end
