require 'rqrcode_png'

class Product < ApplicationRecord
  acts_as_tenant :account
  belongs_to :category
  has_many :purchase_products
  has_many :sale_products
  has_many :group_products
  has_one_attached :image
  has_many :simplo_items

  with_options presence: true do
    validates :name
  end

  def count_purchase_product
    rs = purchase_products.from_store('LojaPrincipal').sum('Quantity')
    sp = purchase_products.from_store('LojaSecundaria').sum('Quantity')
    "#{rs}"
  end

  def count_month_purchase_product(year, month)
    first_day_month = Time.new(year, month.to_i, 1)
    last_day_month = first_day_month.end_of_month
    sum = 0
    purchase_products.where(created_at: first_day_month..last_day_month).each do |pp|
      sum += pp.quantity
    end
    sum
  end

  def count_month_sale_product(year, month)
    first_day_month = Time.new(year, month.to_i, 1)
    last_day_month = first_day_month.end_of_month
    sum = 0
    sale_products.where(created_at: first_day_month..last_day_month).each do |pp|
      sum += pp.quantity
    end
    sum
  end

  def count_sale_product
    rs ||= sale_products.from_sale_store('LojaPrincipal').sum('Quantity')
    sp ||= sale_products.from_sale_store('LojaSecundaria').sum('Quantity')
    "#{rs}"
  end

  def sum_simplo_items
    simplo_items.map(&:quantity).sum
  end

  def balance
    rs = purchase_products.from_store('LojaPrincipal').sum('Quantity')
    sp = purchase_products.from_store('LojaSecundaria').sum('Quantity')
    rs -= sale_products.from_sale_store('LojaPrincipal').sum('Quantity')
    sp -= sale_products.from_sale_store('LojaSecundaria').sum('Quantity')
    "#{rs}"
  end

  def update_active!
    if active.eql? true
      update_attributes(active: false)
    else
      update_attributes(active: true)
    end
  rescue StandardError
    errors.add(:active, message: "não pode ser atualizado")
  end

  DATATABLE_COLUMNS = %w[custom_id name id].freeze

  class << self
    def generate_qrcode(url)
      obj = { id: url.id, custom_id: url.custom_id, name: url.name }
      RQRCode::QRCode.new(obj.to_json)
    end

    def datatable_filter(search_value, search_columns)
      return all if search_value.blank?

      result = none
      search_columns.each do |key, value|
        if DATATABLE_COLUMNS[key.to_i] == 'custom_id'
          filter = where("#{DATATABLE_COLUMNS[key.to_i]} = ?", search_value.to_i)
        else
          filter = where("#{DATATABLE_COLUMNS[key.to_i]} ILIKE ?", "%#{search_value}%")
        end
        result = result.or(filter) if value['searchable']
      end
      result
    end

    def datatable_order(order_column_index, order_dir)
      order_column_index = 1 if order_column_index == 4
      order("#{Product::DATATABLE_COLUMNS[order_column_index]} #{order_dir}")
    end

    def integrate_product(id)
      @order_page = Requests::Product.new(id: id).call
      @order_page['result']['WsprodutoEstoque'].each do |order_page|
        Product.create(name: @order_page['result']['Wsproduto']['nome'],
                       sku: order_page['sku'],
                       price: order_page['valor_venda'],
                       category_id: 1,
                       active: true,
                       account_id: 1)
      rescue ArgumentError
        puts 'erro'
      end
    end
  end
end
