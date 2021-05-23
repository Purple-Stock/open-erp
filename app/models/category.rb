class Category < ApplicationRecord
  has_many :products
  acts_as_tenant :account
end
