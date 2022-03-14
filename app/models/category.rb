class Category < ApplicationRecord
  has_many :products
  acts_as_tenant :account

  # TODO, validates uniqueness of name

  validates_presence_of :name
end
