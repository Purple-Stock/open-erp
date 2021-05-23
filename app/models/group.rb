class Group < ApplicationRecord
  has_many :group_products, inverse_of: :group, dependent: :destroy
  accepts_nested_attributes_for :group_products, reject_if: :all_blank, allow_destroy: true
end
