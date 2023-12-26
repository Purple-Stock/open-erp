# == Schema Information
#
# Table name: productions
#
#  id           :bigint           not null, primary key
#  consider     :boolean          default(FALSE)
#  cut_date     :datetime
#  deliver_date :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  account_id   :integer
#  tailor_id    :bigint
#
# Indexes
#
#  index_productions_on_account_id  (account_id)
#  index_productions_on_tailor_id   (tailor_id)
#
# Foreign Keys
#
#  fk_rails_...  (tailor_id => tailors.id)
#
FactoryBot.define do
  factory :production do
    quantity { 1 }
    cut_date { "2023-12-16 16:28:36" }
    deliver_date { "2023-12-16 16:28:36" }
  end
end
