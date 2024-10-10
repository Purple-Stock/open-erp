FactoryBot.define do
  factory :production_product do
    association :production
    association :product
    quantity { 5 }
    pieces_delivered { 0 }
    dirty { 0 }
    error { 0 }
    discard { 0 }
  end
end