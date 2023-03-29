class Store < ApplicationRecord
  has_many :products
  acts_as_tenant :account
  
  validates :name, presence: true
  validates :address, presence: true
  validates :phone, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
