# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  company_name           :string
#  cpf_cnpj               :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  phone                  :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :account
  before_validation :set_account
  after_create :assign_account

  def assign_account
    ac = Account.find_by(user_id: id)
    ac.update(company_name:)
  end

  def set_account
    build_account
  end
end
