# frozen_string_literal: true

# MonthlyRevenuePresenter returns the hash the Chart js needs.
# From the Char.js doc, https://www.chartjs.org/docs/latest/general/data-structures.html#parsing
# datasets: [{label: 'Custom label 1', data: [1, 2]}, {label: 'Custom label 2', data: [3, 4]}]
class MonthlyRevenuePresenter
  attr_accessor :bling_order_item_collection

  def initialize(bling_order_item_collection)
    @bling_order_item_collection = bling_order_item_collection
  end

  def presentable
    values = []
    12.times do
      values << 0.0
    end

    shein = { label: 'Shein', data: values }
    bling_order_item_collection.shein.group_by { |record| record.date.to_date.month }.map do |month, records|
      shein[:data][month - 1] = records.sum(&:value).to_f
    end

    [shein]
  end
end
