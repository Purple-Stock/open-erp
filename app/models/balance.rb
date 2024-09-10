# == Schema Information
#
# Table name: balances
#
#  id               :bigint           not null, primary key
#  physical_balance :integer          not null
#  virtual_balance  :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  deposit_id       :bigint           not null
#  stock_id         :bigint           not null
#
# Indexes
#
#  index_balances_on_stock_id                 (stock_id)
#  index_balances_on_stock_id_and_deposit_id  (stock_id,deposit_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (stock_id => stocks.id)
#
class Balance < ApplicationRecord
  belongs_to :stock

  validates :deposit_id, :physical_balance, :virtual_balance, presence: true
  validates :physical_balance, :virtual_balance, numericality: { only_integer: true }
end
