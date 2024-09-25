# == Schema Information
#
# Table name: payments
#
#  id            :bigint           not null, primary key
#  amount        :decimal(, )
#  payment_date  :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  production_id :bigint           not null
#
# Indexes
#
#  index_payments_on_production_id  (production_id)
#
# Foreign Keys
#
#  fk_rails_...  (production_id => productions.id)
#
class Payment < ApplicationRecord
  belongs_to :production

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :payment_date, presence: true
end
