# frozen_string_literal: true

# DailyRevenueReport returns the hash the Chart js needs.
# From the Char.js doc, https://www.chartjs.org/docs/latest/general/data-structures.html#parsing
class DailyRevenueReport
  attr_accessor :bling_order_item_collection, :filter, :initial_date, :final_date, :record, :axi_x

  def initialize(bling_order_item_collection, date_filter = nil)
    @bling_order_item_collection = bling_order_item_collection
    @filter = date_filter || { initial_date: Date.today, final_date: Date.today }
    @initial_date = filter[:initial_date]
    @final_date = filter[:final_date]
    @axi_x = filter.values.uniq.map { |date| date.to_date.strftime('%d/%m/%Y') }.join(' - ')
    @record ||= bling_order_item_collection.date_range(initial_date, final_date)
  end

  def presentable
    shein_value_sum = record.shein.sum(&:value).to_f
    shopee_value_sum = record.shopee.sum(&:value).to_f
    simple_7_value_sum = record.simple_7.sum(&:value).to_f
    mercado_livre_value_sum = record.mercado_livre.sum(&:value).to_f
    total = shein_value_sum + shopee_value_sum + simple_7_value_sum + mercado_livre_value_sum
    [{ x: axi_x,
      shein: shein_value_sum,
      shopee: shopee_value_sum,
      simple_7: simple_7_value_sum,
      mercado_livre: mercado_livre_value_sum,
       total: total}]
  end
end
