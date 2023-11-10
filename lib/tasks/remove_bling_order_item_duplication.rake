# frozen_string_literal: true

desc 'Removing BlingOrderItems duplications.'

task remove_bling_order_item_duplication: :environment do
  duplicated_ids = []

  BlingOrderItem.group(:bling_order_id).count.each do |order_id_counter_array|
    duplicated_ids << order_id_counter_array[0] if order_id_counter_array[1] > 1
  end

  BlingOrderItem.where(bling_order_id: duplicated_ids).find_each do |orders|
    duplicated_orders = orders.shift # remove the first from the annihilation.
    duplicated_orders.destroy_all
  end

  puts 'BlingOrderItem duplication removed!'
end
