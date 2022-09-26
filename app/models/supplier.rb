# == Schema Information
#
# Table name: suppliers
#
#  id         :bigint           not null, primary key
#  address    :string
#  cellphone  :string
#  city       :string
#  cnpj       :string
#  email      :string
#  landmark   :string
#  name       :string
#  note       :string
#  phone      :string
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#
# Indexes
#
#  index_suppliers_on_account_id  (account_id)
#
class Supplier < ApplicationRecord
  has_many :purchase_products
end
