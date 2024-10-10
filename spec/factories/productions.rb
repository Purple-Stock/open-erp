# == Schema Information
#
# Table name: productions
#
#  id                     :bigint           not null, primary key
#  confirmed              :boolean
#  consider               :boolean          default(FALSE)
#  cut_date               :datetime
#  expected_delivery_date :date
#  observation            :text
#  paid                   :boolean
#  pieces_missing         :integer
#  service_order_number   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  account_id             :integer
#  tailor_id              :bigint
#
# Indexes
#
#  index_productions_on_account_id              (account_id)
#  index_productions_on_cut_date                (cut_date)
#  index_productions_on_expected_delivery_date  (expected_delivery_date)
#  index_productions_on_tailor_id               (tailor_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (tailor_id => tailors.id)
#
FactoryBot.define do
  factory :production do
    cut_date { Time.current }
    expected_delivery_date { Time.current + 1.week }
    service_order_number { SecureRandom.hex(5) }
    fabric_cost { 0 }
    notions_cost { 0 }
    association :tailor
    association :account

    trait :with_production_products do
      after(:create) do |production|
        create(:production_product, production: production, quantity: 10, product: create(:product, price: 10))
        create(:production_product, production: production, quantity: 5, product: create(:product, price: 10))
      end
    end
  end
end
