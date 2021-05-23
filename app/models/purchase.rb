class Purchase < ApplicationRecord
	has_many :purchase_products, inverse_of: :purchase, dependent: :destroy
	accepts_nested_attributes_for :purchase_products, reject_if: :all_blank, allow_destroy: true
end
