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
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (tailor_id => tailors.id)
#
class Production < ApplicationRecord
  acts_as_tenant :account
  has_many :production_products
  has_many :products, through: :production_products

  accepts_nested_attributes_for :production_products, allow_destroy: true

  belongs_to :tailor, optional: true
end
