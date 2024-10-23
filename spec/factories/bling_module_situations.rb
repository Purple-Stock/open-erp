FactoryBot.define do
  factory :bling_module_situation do
    sequence(:situation_id) { |n| n }
    name { "Situation #{Faker::Lorem.word}" }
    module_id { Faker::Number.number(digits: 2).to_i }  # Ensure this is an integer
    inherited_id { Faker::Number.number(digits: 2) }
    color { Faker::Color.hex_color }
  end
end
