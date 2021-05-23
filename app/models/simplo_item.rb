class SimploItem < ApplicationRecord
  belongs_to :simplo_order
  belongs_to :product, optional: true
end
