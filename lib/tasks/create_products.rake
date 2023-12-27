# frozen_string_literal: true

desc 'Creating Products...'

task create_products: :environment do
  products = []

  100.times do
    products << Product.create(FactoryBot.attributes_for(:product, account_id: 1)
                             .merge({ stock_attributes: FactoryBot.attributes_for(:stock, account_id: 1) }))
  end

  puts "Created #{products.length} products and stocks!"
end
