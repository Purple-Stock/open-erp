# == Schema Information
#
# Table name: stores
#
#  id         :bigint           not null, primary key
#  address    :string
#  email      :string
#  name       :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
# Indexes
#
#  index_stores_on_account_id  (account_id)
#
class Store < ApplicationRecord
  has_many :products
  acts_as_tenant :account
  
  validates :name, presence: true
  validates :address, presence: true
  validates :phone, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
