# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Rails.logger.debug 'Module User'

FactoryBot.create(:user, password: '123456', email: 'fashion.store@email.com')

FactoryBot.create(:bling_datum, account_id: 1, expires_at: (Time.zone.local(13) + 3.days),
                                access_token: ENV['ACCESS_TOKEN'], refresh_token: ENV['REFRESH_TOKEN'])

Rails.logger.debug 'Categories'
50.times { FactoryBot.create(:category, name: Faker::Lorem.word) }
50.times { Category.create(name: Faker::Lorem.word, account_id: 1) }
50.times do
  Product.create(
    name: Faker::Commerce.product_name,
    sku: Faker::Number.number(digits: 10),
    extra_sku: Faker::Number.number(digits: 10),
    price: Faker::Commerce.price,
    active: true,
    account_id: 1,
    category_id: 1
  )
end
50.times do
  Customer.create(name: Faker::Name.name, email: Faker::Internet.email, phone: Faker::PhoneNumber.phone_number,
                  cpf: Faker::Number.number(digits: 11), account_id: 1)
end
50.times { Supplier.create(name: Faker::Lorem.word, account_id: 1) }
# 50.times { Post.create(title: Faker::Lorem.word,content: Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 4), status: true) }
