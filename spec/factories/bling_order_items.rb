# == Schema Information
#
# Table name: bling_order_items
#
#  id                 :bigint           not null, primary key
#  aliquotaIPI        :decimal(, )
#  alteration_date    :datetime
#  codigo             :string
#  date               :datetime
#  desconto           :decimal(, )
#  descricao          :text
#  descricaoDetalhada :text
#  quantidade         :integer
#  unidade            :string
#  valor              :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  bling_order_id     :string
#  situation_id       :string
#  store_id           :string
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
  end
end
