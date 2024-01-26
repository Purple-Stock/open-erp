# == Schema Information
#
# Table name: bling_order_items
#
#  id                        :bigint           not null, primary key
#  aliquotaIPI               :decimal(, )
#  alteration_date           :datetime
#  codigo                    :string
#  collected_alteration_date :date
#  date                      :datetime
#  desconto                  :decimal(, )
#  descricao                 :text
#  descricaoDetalhada        :text
#  items                     :jsonb
#  quantidade                :integer
#  unidade                   :string
#  valor                     :decimal(, )
#  value                     :decimal(, )
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  account_id                :bigint
#  bling_id                  :integer
#  bling_order_id            :string
#  marketplace_code_id       :string
#  situation_id              :string
#  store_id                  :string
#
# Indexes
#
#  index_bling_order_items_on_account_id      (account_id)
#  index_bling_order_items_on_bling_order_id  (bling_order_id) UNIQUE
#
class BlingOrderItem < ApplicationRecord
  # TODO, refactor me separating the tables
  # There are features hard to implement without this separation.

  has_many :items, dependent: :destroy
  belongs_to :account, optional: true

  accepts_nested_attributes_for :items

  before_update :keep_old_collected_alteration_date
  after_create :synchronize_items

  has_enumeration_for :situation_id, with: BlingOrderItemStatus, skip_validation: true
  has_enumeration_for :store_id, with: BlingOrderItemStore, skip_validation: true

  ANOTHER_SHEIN_STORE_ID = '204114350'
  SHEIN_STORE_ID = '204219105'

  STORE_ID_NAME_KEY_VALUE = {
    '204219105' => 'Shein',
    '203737982' => 'Shopee',
    '203467890' => 'Simplo 7',
    '204061683' => 'Mercado Livre',
    '204796870' => 'Nuvem Shop'
  }.freeze

  STATUS_NAME_KEY_VALUE = {
    "15" => 'Em andamento',
    "101065" => 'Checado',
    "24" => 'Verificado',
    "94871" => 'Pendente',
    "95745" => 'Impresso',
    "12" => 'Cancelado',
  }.freeze

  STATUS_PENDING_NAME_KEY_VALUE = {
    "15, 94871, 95745" => 'Pedidos Pagos Pendentes',
    "94871" => 'Pendente',
    "15" => 'Em andamento',
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
    ALL = [IN_PROGRESS, CHECKED, VERIFIED, PENDING, PRINTED, CANCELED, COLLECTED].freeze
    EXCLUDE_DONE = [IN_PROGRESS, PENDING, PRINTED, CANCELED].freeze
    WITHOUT_CANCELLED = [IN_PROGRESS, CHECKED, VERIFIED, PENDING, PRINTED].freeze
    PAID = [IN_PROGRESS, CHECKED, VERIFIED, PENDING, PRINTED, COLLECTED].freeze
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

  scope :date_range, lambda { |initial_date, final_date|
    initial_date = initial_date.try(:to_date).try(:beginning_of_day)
    final_date = final_date.try(:to_date).try(:end_of_day)
    date_range = initial_date..final_date
    where(date: date_range)
  }

  scope :by_status, lambda { |status|
    return all if status.eql?(BlingOrderItemStatus::ALL.to_s)

    where(situation_id: status)
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

  private

  def keep_old_collected_alteration_date
    return unless collected_alteration_date_was.present? && collected_alteration_date_changed?

    self.collected_alteration_date = collected_alteration_date_was
  end
end
