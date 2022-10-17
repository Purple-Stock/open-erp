# frozen_string_literal: true

# == Schema Information
#
# Table name: sales
#
#  id                   :bigint           not null, primary key
#  disclosure           :boolean
#  discount             :float
#  exchange             :boolean          default(FALSE)
#  online               :boolean
#  order_code           :string
#  payment_type         :integer          default("Débito")
#  percentage           :float
#  store_sale           :integer          default("Sem_Loja")
#  total_exchange_value :float
#  value                :float
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  account_id           :integer
#  customer_id          :integer
#
# Indexes
#
#  index_sales_on_account_id   (account_id)
#  index_sales_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
class Sale < ApplicationRecord
  belongs_to :customer, optional: true
  acts_as_tenant :account
  has_many :sale_products, inverse_of: :sale, dependent: :destroy
  accepts_nested_attributes_for :sale_products, reject_if: :all_blank, allow_destroy: true
  enum payment_type: %i[Débito Crédito Dinheiro Débito_Dinheiro Crédito_Dinheiro Depósito Boleto]
  enum store_sale: %i[Sem_Loja LojaPrincipal LojaSecundaria]
  scope :from_sale_store, lambda { |store = store_sales['Sem_Loja']|
                            where('store_sale = ?', store_entrances[store])
                          }

  DATATABLE_COLUMNS = %w[customers.name order_code].freeze
  DATATABLE_COLUMNS_ORDERING = %w[customers.name discount online order_code value disclosure exchange
                                  sales.created_at].freeze
  class << self
    def datatable_filter(search_value, search_columns)
      return all if search_value.blank?

      result = none
      search_columns.each do |key, value|
        filter = where("#{DATATABLE_COLUMNS[key.to_i]} ILIKE ?", "%#{search_value}%")
        result = result.or(filter) if value['searchable']
      end
      result
    end

    def datatable_order(order_column_index, order_dir)
      order("#{Sale::DATATABLE_COLUMNS_ORDERING[order_column_index]} #{order_dir}")
    end
  end
end
