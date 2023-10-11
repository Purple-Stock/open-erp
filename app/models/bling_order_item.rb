# == Schema Information
#
# Table name: bling_order_items
#
#  id                 :bigint           not null, primary key
#  aliquotaIPI        :decimal(, )
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
class BlingOrderItem < ApplicationRecord
  # TODO, refactor me separating the tables
  # There are features hard to implement without this separation.
  STORE_ID_NAME_KEY_VALUE = {
    '204219105' => 'Shein',
    '203737982' => 'Shopee',
    '203467890' => 'Simplo 7',
    '204061683' => 'Mercado Livre'
  }.freeze

  class Status
    IN_PROGRESS = 15
    CHECKED = 24
    PENDING = 94_871
    PRINTED = 95_745
    CANCELED = 12
    ALL = [IN_PROGRESS, CHECKED, PENDING, PRINTED, CANCELED].freeze
  end

  scope :date_range_in_a_day, lambda { |date|
    initial_date = date.beginning_of_day
    end_date = date.end_of_day
    where(date: initial_date..end_date)
  }

  def store_name
    STORE_ID_NAME_KEY_VALUE["#{store_id}"]
  end
end
