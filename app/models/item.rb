# == Schema Information
#
# Table name: items
#
#  id                  :bigint           not null, primary key
#  description         :string
#  discount            :decimal(, )
#  ipi_tax             :decimal(, )
#  long_description    :string
#  pending             :boolean          default(FALSE)
#  quantity            :integer
#  resolved            :boolean          default(FALSE)
#  sku                 :string
#  unity               :integer
#  value               :decimal(, )
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  account_id          :integer
#  bling_order_item_id :bigint
#  product_id          :bigint
#
# Indexes
#
#  index_items_on_resolved  (resolved)
#
class Item < ApplicationRecord
  belongs_to :account
  belongs_to :bling_order_item

  scope :unresolved, -> { where(resolved: false) }
  scope :resolved, -> { where(resolved: true) }

  def resolve!
    update(resolved: true)
  end

  def unresolve!
    update(resolved: false)
  end
end
