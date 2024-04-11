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
FactoryBot.define do
  factory :item do
    sku { "MyString" }
    unity { 1 }
    quantity { 1 }
    discount { "9.99" }
    value { "9.99" }
    ipi_tax { "9.99" }
    description { "MyString" }
    long_description { "MyString" }
    product_id { 1 }
    account_id { 1 }
  end
end
