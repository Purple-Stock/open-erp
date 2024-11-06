# == Schema Information
#
# Table name: bling_order_items
#
#  id                        :bigint           not null, primary key
#  aliquotaIPI               :decimal(, )
#  alteration_date           :datetime
#  city                      :string(10485760)
#  codigo                    :string
#  collected_alteration_date :date
#  date                      :datetime
#  desconto                  :decimal(, )
#  descricao                 :text
#  descricaoDetalhada        :text
#  items                     :jsonb
#  quantidade                :integer
#  state                     :string(10485760)
#  unidade                   :string
#  valor                     :decimal(, )
#  value                     :decimal(, )
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  account_id                :bigint
#  bling_id                  :integer
#  bling_order_id            :string
#  marketplace_code_id       :string
#  original_situation_id     :string
#  situation_id              :string
#  store_id                  :string
#
# Indexes
#
#  bling_order_id_index_on_bling_order_items  (bling_order_id)
#  index_bling_order_items_on_account_id      (account_id)
#  index_bling_order_items_on_bling_order_id  (bling_order_id) UNIQUE
#  situation_id_index_on_bling_order_items    (situation_id,store_id)
#
class BlingOrderItem < ApplicationRecord
  # TODO, refactor me separating the tables
  # There are features hard to implement without this separation.

  has_many :items, dependent: :destroy
  has_one :localization, dependent: :destroy
  belongs_to :account, optional: true

  accepts_nested_attributes_for :items

  before_update :keep_old_collected_alteration_date
  after_create :synchronize_items

  has_enumeration_for :situation_id, with: BlingOrderItemStatus, skip_validation: true
  has_enumeration_for :store_id, with: BlingOrderItemStore, skip_validation: true

  after_update_commit -> { broadcast_update_to self, partial: 'bling_order_items/bling_order_item_content', target: "bling_order_item_#{id}" if saved_change_to_situation_id? }

  ANOTHER_SHEIN_STORE_ID = '204114350'
  SHEIN_STORE_ID = '204219105'

  STORE_ID_NAME_KEY_VALUE = {
    '204219105' => 'Shein',
    '203737982' => 'Shopee',
    '203467890' => 'Simplo 7',
    '204061683' => 'Mercado Livre',
    '204796870' => 'Nuvem Shop',
    '204824954' => 'Feira da Madrugada',
    '205002864' => 'Magazine Luiza',
    '0' => 'Sem Loja'
  }.freeze

  STORE_NAME_KEY_VALUE = {
    '204219105' => 'Shein',
    '203737982' => 'Shopee',
    '204061683' => 'Mercado Livre',
    '204796870' => 'Nuvem Shop',
    '205002864' => 'Magazine Luiza',
  }.freeze

  STATUS_NAME_KEY_VALUE = {
    "15" => 'Em andamento',
    "9" => 'Atendido',
    "101065" => 'Checado',
    "24" => 'Verificado',
    "94871" => 'Pendente',
    "95745" => 'Impresso',
    "12" => 'Cancelado',
    "215138" => 'Erro'
  }.freeze

  STATUS_PENDING_NAME_KEY_VALUE = {
    "15, 9, 94871, 95745" => 'Pedidos Pagos Pendentes',
    "94871" => 'Pendente',
    "15" => 'Em andamento',
    "9" => 'Atendido',
    "95745" => 'Impresso',
  }.freeze

  class Status
    IN_PROGRESS = 15
    CHECKED = 101_065
    VERIFIED = 24
    PENDING = 94_871
    PRINTED = 95_745
    CANCELED = 12
    COLLECTED = 173_631
    FULFILLED = 9
    ERROR = 215138
    ALL = [IN_PROGRESS, CHECKED, ERROR, VERIFIED, PENDING, PRINTED, CANCELED, COLLECTED, FULFILLED].freeze
    EXCLUDE_DONE = [IN_PROGRESS, PENDING, PRINTED, CANCELED].freeze
    WITHOUT_CANCELLED = [IN_PROGRESS, CHECKED, ERROR, VERIFIED, PENDING, PRINTED, FULFILLED].freeze
    PAID = [IN_PROGRESS, CHECKED, VERIFIED, ERROR, PENDING, PRINTED, COLLECTED, FULFILLED].freeze
  end

  scope :date_range_in_a_day, lambda { |date|
    initial_date = date.beginning_of_day
    end_date = date.end_of_day
    where(date: initial_date..end_date)
  }

  scope :shein, lambda {
    where(store_id: '204219105')
  }

  scope :shopee, lambda {
    where(store_id: '203737982')
  }

  scope :simple_7, lambda {
    where(store_id: '203467890')
  }

  scope :mercado_livre, lambda {
    where(store_id: '204061683')
  }

  scope :feira_madrugada, lambda {
    where(store_id: '204824954')
  }

  scope :nuvem_shop, lambda {
    where(store_id: '204796870')
  }

  scope :magazine_luiza, lambda {
    where(store_id: '205002864')
  }

  scope :date_range, ->(start_date, end_date) { 
    start_date = start_date.to_date.beginning_of_day if start_date.present?
    end_date = end_date.to_date.end_of_day if end_date.present?
    where(date: start_date..end_date)
  }

  def self.flexible_date_range(start_date, end_date)
    start_date = parse_date(start_date)
    end_date = parse_date(end_date)

    if start_date && end_date
      where(date: start_date.beginning_of_day..end_date.end_of_day)
    elsif start_date
      where('date >= ?', start_date.beginning_of_day)
    elsif end_date
      where('date <= ?', end_date.end_of_day)
    else
      where(date: Time.zone.today.beginning_of_day..Time.zone.today.end_of_day)
    end
  end

  scope :by_status, lambda { |status|
    return all if status.eql?(BlingOrderItemStatus::ALL)

    where(situation_id: status)
  }

  scope :by_store, lambda { |store_id|
    return all if store_id.eql?(BlingOrderItemStore::ALL)

    where(store_id:)
  }

  def self.group_order_items(base_query)
    grouped_order_items = {}
    STORE_ID_NAME_KEY_VALUE.each_value { |store| grouped_order_items[store] = [] }

    grouped_order_items.merge!(
      base_query
      .group_by(&:store_id)
      .transform_keys { |store_id| STORE_ID_NAME_KEY_VALUE.fetch(store_id) }
    )
  end

  def self.selected_group_order_items(base_query)
    grouped_order_items = {}
    STORE_NAME_KEY_VALUE.each_value { |store| grouped_order_items[store] = [] }

    grouped_order_items.merge!(
      base_query
      .group_by(&:store_id)
      .transform_keys { |store_id| STORE_NAME_KEY_VALUE.fetch(store_id) }
    )
  end

  def self.update_yourself(self_collection)
    account_id = self_collection.first.account_id

    GoodJob::Bulk.enqueue do
      self_collection.each do |record|
        BlingOrderJobUpdater.perform_later(record, account_id)
      end
    end
  end

  def store_name
    STORE_ID_NAME_KEY_VALUE["#{store_id}"]
  end

  def store_id
    if super.eql?(ANOTHER_SHEIN_STORE_ID)
      SHEIN_STORE_ID
    else
      super
    end
  end

  def collected!
    update(situation_id: 173_631)
  end

  def deleted_at_bling!
    return if processing_deletion?

    update(situation_id: BlingOrderItemStatus::DELETE_IN_PROGRESS, original_situation_id: situation_id_was)
    BlingOrderItemDestroyerJob.perform_later(bling_order_id)
  end

  def value
    super || 0.0
  end

  def synchronize_items
    return unless items.empty?

    OrderItemsJob.perform_later(bling_order_id)
  end

  def self.bulk_synchronize_items(collection)
    GoodJob::Bulk.enqueue do
      collection.each(&:synchronize_items)
    end
  end

  def not_found_at_bling?
    result = Services::Bling::FindOrder.call(id: bling_order_id, order_command: 'find_order', tenant: account_id)
    if result['error'].present? && result['error']['type'] != 'RESOURCE_NOT_FOUND'
      raise StandardError, result['error']['type']
    end

    result.dig('error', 'type') == 'RESOURCE_NOT_FOUND'
  end

  private

  def processing_deletion?
    situation_id.eql?(BlingOrderItemStatus::DELETED_AT_BLING)\
      || situation_id.eql?(BlingOrderItemStatus::DELETE_IN_PROGRESS)
  end

  def keep_old_collected_alteration_date
    return unless collected_alteration_date_was.present? && collected_alteration_date_changed?

    self.collected_alteration_date = collected_alteration_date_was
  end

  scope :date_range, ->(start_date, end_date) { 
    start_date = start_date.to_date.beginning_of_day if start_date.present?
    end_date = end_date.to_date.end_of_day if end_date.present?
    where(date: start_date..end_date)
  }

  def self.parse_date(date)
    case date
    when String
      Date.parse(date) rescue nil
    when Date, Time, DateTime
      date.to_date
    else
      nil
    end
  end
end
