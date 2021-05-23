class Customer < ApplicationRecord
  has_many :sales
  acts_as_tenant :account
end
