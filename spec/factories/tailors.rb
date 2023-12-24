# == Schema Information
#
# Table name: tailors
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
# Indexes
#
#  index_tailors_on_account_id  (account_id)
#
FactoryBot.define do
  factory :tailor do
    name { "MyString" }
  end
end
