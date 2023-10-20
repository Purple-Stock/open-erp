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
require 'rails_helper'

RSpec.describe BlingOrderItem, type: :model do
  describe '#store_name' do
    it 'has name' do
      subject.store_id = '204219105'
      expect(subject.store_name).to eq('Shein')
    end
  end

  describe '#Status::ALL' do
    it 'has status all' do
      expect(described_class::Status::ALL).to eq([15, 101_065, 24, 94_871, 95_745, 12])
    end
  end
end
