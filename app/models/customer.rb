# frozen_string_literal: true

# == Schema Information
#
# Table name: customers
#
#  id         :bigint           not null, primary key
#  cellphone  :string
#  cpf        :string
#  email      :string
#  name       :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
# Indexes
#
#  index_customers_on_account_id  (account_id)
#
class Customer < ApplicationRecord
  has_many :sales
  acts_as_tenant :account

  validates :name, presence: true
  validates :cpf, presence: true, uniqueness: true, length: { is: 14 }, allow_blank: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
  validates :cellphone, presence: true

end
