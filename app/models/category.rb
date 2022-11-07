# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
# Indexes
#
#  index_categories_on_account_id  (account_id)
#
class Category < ApplicationRecord
  has_many :products
  acts_as_tenant :account

  # TODO, validates uniqueness of name

  validates :name, presence: true
end
