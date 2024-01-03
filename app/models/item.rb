# == Schema Information
#
# Table name: items
#
#  id                  :bigint           not null, primary key
#  description         :string
#  discount            :decimal(, )
#  ipi_tax             :decimal(, )
#  long_description    :string
#  quantity            :integer
#  sku                 :string
#  unity               :integer
#  value               :decimal(, )
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  account_id          :integer
#  bling_order_item_id :bigint
#  product_id          :bigint
#
class Item < ApplicationRecord
  belongs_to :account
  belongs_to :product
  belongs_to :bling_order_item
end
