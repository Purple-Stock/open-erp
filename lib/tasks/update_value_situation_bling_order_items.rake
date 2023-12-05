# frozen_string_literal: true

desc 'Updating values from nil to its real value.'

task update_value_situation_bling_order_items: :environment do
  collection_whose_value_is_nil = BlingOrderItem.where(value: nil)

  puts "There are #{collection_whose_value_is_nil.length} whose values are nil"

  BlingOrderItem.update_yourself(collection_whose_value_is_nil)

  puts 'BlingOrderItem values and situation updated!'
  puts "Now, there are #{BlingOrderItem.where(value: nil).length} nil values."
end
