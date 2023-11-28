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
    [dataset_structure('shein'), dataset_structure('shopee'),
     dataset_structure('simple_7'), dataset_structure('mercado_livre')]
  end

  def dataset_structure(store_name)
    values = []
    12.times do
      values << 0.0
    end

    labeled_store_name = store_name.split('_').map(&:capitalize).join(' ')

    store_dataset = { label: labeled_store_name, data: values }

    bling_order_item_collection.send(store_name.to_sym).group_by { |record| record.date.to_date.month }.map do |month, records|
      store_dataset[:data][month - 1] = records.sum(&:value).to_f
    end

    store_dataset
  end
end
