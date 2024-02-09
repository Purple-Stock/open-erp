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
class AccountFeature < ApplicationRecord
  belongs_to :account
  belongs_to :feature

  before_create :enable_stock

  private

  def enable_stock
    return if feature.bling_integration?

    self.is_enabled = true
  end
end
