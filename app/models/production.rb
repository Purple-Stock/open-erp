# == Schema Information
#
# Table name: productions
#
#  id                     :bigint           not null, primary key
#  confirmed              :boolean
#  consider               :boolean          default(FALSE)
#  cut_date               :datetime
#  expected_delivery_date :date
#  fabric_cost            :decimal(10, 2)
#  notions_cost           :decimal(10, 2)
#  observation            :text
#  paid                   :boolean
#  pieces_missing         :integer
#  service_order_number   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  account_id             :integer
#  tailor_id              :bigint
#  payment_date           :date
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

  accepts_nested_attributes_for :production_products, allow_destroy: true, reject_if: :all_blank

  has_many :payments, dependent: :destroy
  accepts_nested_attributes_for :payments, allow_destroy: true, reject_if: :all_blank

  validates :cut_date, presence: true
  validates :tailor, presence: true
  validates :account, presence: true
  validates :service_order_number, uniqueness: { scope: :account_id }

  # Add a method to calculate total pieces delivered
  def total_pieces_delivered
    production_products.sum(&:pieces_delivered)
  end

  # Add a method to calculate total pieces missing
  def total_missing_pieces
    production_products.sum do |pp|
      next 0 if pp.returned
      pp.quantity - ((pp.pieces_delivered || 0) + (pp.dirty || 0) + (pp.error || 0) + (pp.discard || 0))
    end
  end

  def total_dirty_pieces
    production_products.sum(&:dirty)
  end

  def total_error_pieces
    production_products.sum(&:error)
  end

  def total_discarded_pieces
    production_products.sum(&:discard)
  end

  def total_missing_pieces
    production_products.sum do |pp|
      next 0 if pp.returned
      pp.quantity - ((pp.pieces_delivered || 0) + (pp.dirty || 0) + (pp.error || 0) + (pp.discard || 0))
    end
  end

  # Remove the before_save callback and the calculate_total_material_cost method
  # before_save :calculate_total_material_cost

  # private

  # def calculate_total_material_cost
  #   self.total_material_cost = (notions_cost || 0) + (fabric_cost || 0)
  # end

  def price_per_piece
    total_cost = (notions_cost || 0) + (fabric_cost || 0)
    total_quantity = production_products.sum(&:quantity)
    
    total_quantity.zero? ? 0 : (total_cost / total_quantity)
  end

  def total_price
    production_products.sum(:total_price)
  end

  def total_paid
    payments.sum(:amount)
  end

  def remaining_balance
    total_price - total_paid
  end
end
