# == Schema Information
#
# Table name: account_features
#
#  id         :bigint           not null, primary key
#  is_enabled :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint           not null
#  feature_id :integer          not null
#
FactoryBot.define do
  factory :account_feature do
    account_id { 1 }
    feature_id { 1 }
    is_enabled { false }
  end
end
