# == Schema Information
#
# Table name: bling_order_items
#
#  id                 :bigint           not null, primary key
#  aliquotaIPI        :decimal(, )
#  codigo             :string
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
class BlingOrderItem < ApplicationRecord
end
