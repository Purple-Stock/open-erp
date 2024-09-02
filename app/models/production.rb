# == Schema Information
#
# Table name: productions
#
#  id                     :bigint           not null, primary key
#  confirmed              :boolean
#  consider               :boolean          default(FALSE)
#  cut_date               :datetime
#  deliver_date           :datetime
#  expected_delivery_date :date
#  observation            :text
#  paid                   :boolean
#  pieces_delivered       :integer
#  pieces_missing         :integer
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
class Production < ApplicationRecord
  acts_as_tenant(:account)
  
  belongs_to :tailor
  has_many :production_products, dependent: :destroy
  has_many :products, through: :production_products

  accepts_nested_attributes_for :production_products, allow_destroy: true

  validates :cut_date, presence: true
  validates :tailor, presence: true
  validates :account, presence: true

  # Add a method to calculate total pieces delivered
  def total_pieces_delivered
    production_products.sum(:pieces_delivered)
  end

  # Add a method to calculate total pieces missing
  def total_pieces_missing
    production_products.sum { |pp| pp.quantity - (pp.pieces_delivered || 0) }
  end
end
