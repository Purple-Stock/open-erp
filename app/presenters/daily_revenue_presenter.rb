# frozen_string_literal: true

# DailyRevenuePresenter returns the hash the Chart js needs.
# From the Char.js doc, https://www.chartjs.org/docs/latest/general/data-structures.html#parsing
class DailyRevenuePresenter
  attr_accessor :bling_order_item_collection, :filter, :initial_date, :final_date

  def initialize(bling_order_item_collection, date_filter = nil)
    @bling_order_item_collection = bling_order_item_collection
    @filter = date_filter || { initial_date: Date.today, final_date: Date.today }
    @initial_date = filter[:initial_date]
    @final_date = filter[:final_date]
  end

  def presentable
    zeros_datasets = [{ x: initial_date.strftime('%d/%m/%Y'), shein: 0.0, shopee: 0.0, simple_7: 0.0,
                        mercado_livre: 0.0 }]
    return zeros_datasets if bling_order_item_collection.blank?

    datasets = []

    record.group_by(&:date).map do |date, record|
      axis_date = date.strftime('%d/%m/%Y')
      shein_value = store_value_sum(record, '204219105')
      shopee_value = store_value_sum(record,'203737982')
      simple_7_value = store_value_sum(record, '203467890')
      mercado_livre_value = store_value_sum(record, '204061683')
      datasets << { x: axis_date,
                    shein: shein_value,
                    shopee: shopee_value,
                    simple_7: simple_7_value,
                    mercado_livre: mercado_livre_value }
    end

    datasets
  end

  private

  def store_value_sum(record, store_id)
    record.select { |object| object.store_id.eql?(store_id) }.sum(&:value).to_d
  end

  def record
    bling_order_item_collection.date_range(initial_date, final_date)
  end
end
