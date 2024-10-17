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
#  payment_date           :date
#  pieces_missing         :integer
#  service_order_number   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  account_id             :integer
#  tailor_id              :bigint
#
# Indexes
#
#  index_productions_on_account_id              (account_id)
#  index_productions_on_confirmed               (confirmed)
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
    production_products.sum { |pp| pp.pieces_delivered || 0 }
  end

  # Add a method to calculate total pieces missing
  def total_missing_pieces
    production_products.sum do |pp|
      next 0 if pp.returned
      (pp.quantity || 0) - (
        (pp.pieces_delivered || 0) + 
        (pp.dirty || 0) + 
        (pp.error || 0) + 
        (pp.discard || 0) + 
        (pp.lost_pieces || 0)
      )
    end
  end

  def total_dirty_pieces
    production_products.sum { |pp| pp.dirty || 0 }
  end

  def total_error_pieces
    production_products.sum { |pp| pp.error || 0 }
  end

  def total_discarded_pieces
    production_products.sum { |pp| pp.discard || 0 }
  end

  def total_lost_pieces
    production_products.sum { |pp| pp.lost_pieces || 0 }
  end

  # Remove the before_save callback and the calculate_total_material_cost method
  # before_save :calculate_total_material_cost

  # private

  # def calculate_total_material_cost
  #   self.total_material_cost = (notions_cost || 0) + (fabric_cost || 0)
  # end

  def price_per_piece
    total_cost = (notions_cost || 0) + (fabric_cost || 0)
    total_quantity = production_products.sum { |pp| pp.quantity || 0 }
    
    total_quantity.zero? ? 0 : (total_cost / total_quantity)
  end

  def total_price
    production_products.sum do |pp|
      next 0 if pp.returned
      quantity = pp.quantity || 0
      unit_price = pp.unit_price || 0
      quantity * unit_price
    end
  end

  def total_paid
    payments.sum(:amount)
  end

  def remaining_balance
    total_price - total_paid
  end

  def calendar_date
    if confirmed?
      payment_date
    else
      expected_delivery_date
    end
  end

  def total_value_delivered
    production_products.sum { |pp| pp.pieces_delivered * pp.unit_price }
  end
end
