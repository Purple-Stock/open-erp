# frozen_string_literal: true

# == Schema Information
#
# Table name: purchases
#
#  id          :bigint           not null, primary key
#  value       :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  supplier_id :bigint
#
# Indexes
#
#  index_purchases_on_supplier_id  (supplier_id)
#
# Foreign Keys
#
#  fk_rails_...  (supplier_id => suppliers.id)
#
class Purchase < ApplicationRecord
  has_many :purchase_products, inverse_of: :purchase, dependent: :destroy
  accepts_nested_attributes_for :purchase_products, reject_if: :all_blank, allow_destroy: true
end
