class Category < ApplicationRecord
  has_many :products
  acts_as_tenant :account

  validates_presence_of :name
end
