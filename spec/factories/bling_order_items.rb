# == Schema Information
#
# Table name: bling_order_items
#
#  id                  :bigint           not null, primary key
#  aliquotaIPI         :decimal(, )
#  alteration_date     :datetime
#  codigo              :string
#  date                :datetime
#  desconto            :decimal(, )
#  descricao           :text
#  descricaoDetalhada  :text
#  quantidade          :integer
#  unidade             :string
#  valor               :decimal(, )
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  account_id          :bigint
#  bling_id            :integer
#  bling_order_id      :string
#  marketplace_code_id :string
#  situation_id        :string
#  store_id            :string
#
# Indexes
#
#  index_bling_order_items_on_account_id      (account_id)
#  index_bling_order_items_on_bling_order_id  (bling_order_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
FactoryBot.define do
  factory :bling_order_item do
    codigo { "MyString" }
    unidade { "MyString" }
    quantidade { 1 }
    desconto { "9.99" }
    valor { "9.99" }
    aliquotaIPI { "9.99" }
    descricao { "MyText" }
    descricaoDetalhada { "MyText" }
    situation_id { BlingOrderItem::Status::CHECKED }
    bling_order_id { Faker::Number.number }
    date { Date.today }
    store_id { BlingOrderItem::STORE_ID_NAME_KEY_VALUE['Shein'] }
    account_id { 1 }
  end
end
