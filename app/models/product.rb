# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  active      :boolean
#  bar_code    :string
#  extra_sku   :string
#  highlight   :boolean
#  name        :string
#  price       :float
#  sku         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :integer
#  bling_id    :bigint
#  category_id :bigint
#  custom_id   :integer
#  store_id    :integer
#
# Indexes
#
#  index_products_on_account_id   (account_id)
#  index_products_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
class Product < ApplicationRecord
  acts_as_tenant :account
  belongs_to :category, optional: true
  has_many :purchase_products
  has_many :sale_products
  has_many :group_products
  has_one_attached :image
  has_many :simplo_items
  has_one :store
  has_one :stock, dependent: :destroy

  with_options presence: true do
    validates :name
    validates :price, numericality: { greater_than_or_equal_to: 0 }
  end

  accepts_nested_attributes_for :stock

  def self.synchronize_bling(tenant, options = {})
    attributes = []
    response = Services::Bling::Product.call(product_command: 'find_products', tenant:, options:)
    products = Product.where(account_id: tenant)
    response['data'].each do |bling_product|
      if products.exists?(bling_id: bling_product['id'])
        update_product(bling_product)
      else
        attributes << {
          name: bling_product['nome'],
          price: bling_product['preco'],
          sku: bling_product['codigo'],
          active: bling_product['situacao'].eql?('A'),
          account_id: tenant,
          bling_id: bling_product['id']
        }
      end
    end

    Product.create(attributes)
  end

  def self.update_product(bling_product)
    attributes = {
      name: bling_product['nome'],
      price: bling_product['preco'],
      sku: bling_product['codigo'],
      active: bling_product['situacao'].eql?('A'),
    }
    product = where(bling_id: bling_product['id'])
    product.update(attributes)
  end

  def bling?
    bling_id.blank? ? I18n.translate('activerecord.attributes.product.bling.false') : I18n.translate('activerecord.attributes.product.bling.true')
  end

  def count_month_purchase_product(year, month)
    first_day_month = Time.zone.local(year, month.to_i, 1)
    last_day_month = first_day_month.end_of_month
    sum = 0
    purchase_products.where(created_at: first_day_month..last_day_month).find_each do |purchase_product|
      sum += purchase_product.quantity
    end
    sum
  end

  def count_month_sale_product(year, month)
    first_day_month = Time.zone.local(year, month.to_i, 1)
    last_day_month = first_day_month.end_of_month
    sum = 0
    sale_products.where(created_at: first_day_month..last_day_month).find_each do |sale_product|
      sum += sale_product.quantity
    end
    sum
  end

  def sum_simplo_items
    simplo_items.map(&:quantity).sum
  end

  DATATABLE_COLUMNS = %w[custom_id name id].freeze

  class << self
    def datatable_filter(search_value, search_columns)
      return all if search_value.blank?

      result = none
      search_columns.each do |key, value|
        filter = if DATATABLE_COLUMNS[key.to_i] == 'custom_id'
                   where("#{DATATABLE_COLUMNS[key.to_i]} = ?", search_value.to_i)
                 else
                   where("#{DATATABLE_COLUMNS[key.to_i]} ILIKE ?", "%#{search_value}%")
                 end
        result = result.or(filter) if value['searchable']
      end
      result
    end

    def datatable_order(order_column_index, order_dir)
      order_column_index = 1 if order_column_index == 4
      order("#{Product::DATATABLE_COLUMNS[order_column_index]} #{order_dir}")
    end
  end

  private

  def synchronize_stock
    Stock.synchronize_bling(account_id, [bling_id])
  end
end
