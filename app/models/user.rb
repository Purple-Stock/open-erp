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
    ac.update(company_name: company_name)
  end

  def set_account
    build_account
  end
end
