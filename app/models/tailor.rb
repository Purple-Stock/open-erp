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
class Tailor < ApplicationRecord
  acts_as_tenant :account
  has_many :productions
  belongs_to :account
  validates :name, presence: true
end
