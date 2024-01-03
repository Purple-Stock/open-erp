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
#  items               :jsonb
#  quantidade          :integer
#  unidade             :string
#  valor               :decimal(, )
#  value               :decimal(, )
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
require 'rails_helper'

RSpec.describe BlingOrderItem, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:items).dependent(:destroy) }
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:items) }
  end

  describe '#synchronize_items' do
    subject(:synchronize_items) { order.synchronize_items }

    include_context 'with bling token'

    let(:order) { FactoryBot.create(:bling_order_item, bling_order_id: 19_178_587_026, account_id: user.account.id) }

    before do
      VCR.use_cassette('find_order', erb: true) do
        synchronize_items
      end
    end

    it 'counts 1 item' do
      expect(order.items.length).to eq(1)
    end

    it 'has quantity 1' do
      expect(order.items.first.quantity).to eq(1)
    end
  end

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

  describe '#Status::PAID' do
    it 'has status paid' do
      expect(described_class::Status::PAID).to eq([15, 101_065, 24, 94_871, 95_745])
    end
  end

  describe 'scopes' do
    before do
      store_ids = %w[204219105 203737982 203467890 204061683]
      store_ids.each do |store_id|
        FactoryBot.create(:bling_order_item, store_id: store_id)
      end
    end

    context '#shein' do
      it 'counts 1' do
        expect(BlingOrderItem.shein.count).to eq(1)
      end
    end

    context '#shopee' do
      it 'counts 1' do
        expect(BlingOrderItem.shopee.count).to eq(1)
      end
    end

    context '#simple_7' do
      it 'counts 1' do
        expect(BlingOrderItem.simple_7.count).to eq(1)
      end
    end

    context '#mercado_livre' do
      it 'counts 1' do
        expect(BlingOrderItem.mercado_livre.count).to eq(1)
      end
    end
  end

  describe 'self.date_range' do
    before do
      described_class.destroy_all
      [23, 24, 25].each do |day|
        FactoryBot.create(:bling_order_item, date: "2023-10-#{day}", bling_order_id: day)
      end
    end

    context 'when it has initial date' do
      let(:initial_date) { '2023-10-23' }
      let(:final_date) { nil }

      it 'counts 3' do
        expect(described_class.date_range(initial_date, final_date).length).to eq(3)
      end
    end

    context 'when it has initial date and final_date' do
      let(:initial_date) { '2023-10-23' }
      let(:final_date) { '2023-10-24' }

      it 'counts 2' do
        expect(described_class.date_range(initial_date, final_date).length).to eq(2)
      end
    end

    context 'when it has final_date only' do
      let(:initial_date) { nil }
      let(:final_date) { '2023-10-24' }

      it 'counts 2' do
        expect(described_class.date_range(initial_date, final_date).length).to eq(2)
      end
    end

    context 'when initial_date and final_date are nil' do
      let(:initial_date) { nil }
      let(:final_date) { nil }

      it 'counts 3' do
        expect(described_class.date_range(initial_date, final_date).length).to eq(3)
      end
    end
  end

  describe '#group_order_items' do
    subject { described_class.group_order_items(described_class.all) }

    context 'when there\'s BlinOrderItem for all stores' do
      let!(:shein_order_item) { FactoryBot.create(:bling_order_item, store_id: 204_219_105) }
      let!(:shopee_order_item) { FactoryBot.create(:bling_order_item, store_id: 203_737_982) }
      let!(:simplo7_order_item) { FactoryBot.create(:bling_order_item, store_id: 203_467_890) }
      let!(:mercado_livre_order_item) { FactoryBot.create(:bling_order_item, store_id: 204_061_683) }

      it 'return a hash with all stores' do
        expect(subject).to(match({
                                   'Shein' => [shein_order_item],
                                   'Shopee' => [shopee_order_item],
                                   'Simplo 7' => [simplo7_order_item],
                                   'Mercado Livre' => [mercado_livre_order_item]
                                 }))
      end
    end

    context 'when store has no BlingOrderItem' do
      let!(:shein_order_item) { FactoryBot.create(:bling_order_item, store_id: 204_219_105) }

      it 'return the corresponding store with empty array' do
        expect(subject).to(match({
                                   'Shein' => [shein_order_item],
                                   'Shopee' => [],
                                   'Simplo 7' => [],
                                   'Mercado Livre' => []
                                 }))
      end
    end
  end

  describe '#update_yourself' do
    context 'when there are in progress orders' do
      let(:incorrect_situation) { 99 }
      let(:collection) { described_class.where(value: nil, situation_id: incorrect_situation) }
      let(:order_ids) do
        %w[19270144097 19270112818 19270079777 19269718202]
      end

      before do
        FactoryBot.create(:bling_datum)

        order_ids.each do |order_id|
          FactoryBot.create(:bling_order_item, bling_order_id: order_id, value: nil, situation_id: incorrect_situation)
        end
      end

      context 'when there is no error in response' do
        it 'updates value' do
          VCR.use_cassette('find_checked_order', erb: true) do
            described_class.update_yourself(collection)
            expect(collection.first.reload.value.to_f).to eq(69.9)
          end
        end
      end

      context 'when there are too many requests error in the response' do
        it 'does not raise StandardError with message' do
          VCR.use_cassette('find_checked_order_with_error_too_many_requests', erb: true) do
            expect { described_class.update_yourself(collection) }.not_to raise_error(StandardError)
          end
        end
      end
    end
  end
end
