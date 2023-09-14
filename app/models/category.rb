# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  slug       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
# Indexes
#
#  index_categories_on_account_id  (account_id)
#  index_categories_on_slug        (slug) UNIQUE
#
class Category < ApplicationRecord
  extend FriendlyId
  
  friendly_id :name, use: :slugged
  has_many :products
  acts_as_tenant :account

  # TODO, validates uniqueness of name

  validates :name, presence: true
end
