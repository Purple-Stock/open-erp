# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id           :bigint           not null, primary key
#  company_name :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_accounts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Account < ApplicationRecord
  has_many :account_features
  has_many :features, through: :account_features

  belongs_to :user

  before_create :set_account_features

  private

  def set_account_features
    features << Feature.where(feature_key: [FeatureKey::STOCK, FeatureKey::BLING_INTEGRATION])
  end
end
