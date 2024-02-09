# == Schema Information
#
# Table name: features
#
#  id          :bigint           not null, primary key
#  feature_key :integer          default(0), not null
#  is_enabled  :boolean          default(FALSE), not null
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Feature < ApplicationRecord
  has_many :account_features
  has_many :accounts, through: :account_features

  has_enumeration_for :feature_key, create_helpers: true
end
