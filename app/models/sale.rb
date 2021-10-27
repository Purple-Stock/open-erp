# frozen_string_literal: true

class Sale < ApplicationRecord
  belongs_to :customer, optional: true
  acts_as_tenant :account
  has_many :sale_products, inverse_of: :sale, dependent: :destroy
  accepts_nested_attributes_for :sale_products, reject_if: :all_blank, allow_destroy: true
  enum payment_type: %i[Débito Crédito Dinheiro Débito_Dinheiro Crédito_Dinheiro Depósito Boleto]
  enum store_sale: %i[Sem_Loja PurchaseStoreRS PurchaseStoreSP]
  scope :from_sale_store, lambda { |store = store_sales['Sem_Loja']|
                            where('store_sale = ?', store_entrances[store])
                          }

  def self.integrate_orders(id, store_sale)
    sale = Sale.where(order_code: id).first
    id = (id.to_i + 1).to_s
    if sale.nil?
      order = Requests::Order.new(id: id).call

      customer = Customer.where(cpf: order['result']['Wspedido']['cliente_cpfcnpj'].delete('.-')).first
      customer = Customer.where(cpf: order['result']['Wspedido']['cliente_cpfcnpj']).first if customer.nil?
      if customer.nil?
        customer = Customer.create(cpf: order['result']['Wspedido']['cliente_cpfcnpj'],
                                   name: order['result']['Wspedido']['cliente_razaosocial'],
                                   cellphone: order['result']['Wspedido']['cliente_telefone'],
                                   email: order['result']['Wspedido']['cliente_email'])
      end
      if customer.present?
        sale = Sale.create(online: true,
                           customer_id: customer.id,
                           created_at: DateTime.parse(order['result']['Wspedido']['data_pedido']),
                           order_code: order['result']['Wspedido']['numero'],
                           value: order['result']['Wspedido']['total_produtos'],
                           discount: order['result']['Wspedido']['total_descontos'],
                           payment_type: order['result']['Pagamento']['integrador'] == 'Depósito Bancário' ? 'Depósito' : 'Crédito',
                           store_sale: store_sale)
        order['result']['Item'].each do |item|
          product = Product.where(sku: item['sku']).or(Product.where(extra_sku: item['sku'])).first
          if product.present?
            SaleProduct.create(quantity: item['quantidade'], value: item['valor_total'].to_f, product_id: product.id,
                               sale_id: sale.id)
          else
            puts "Product Not Found - Pedido #{id}"
          end
        end
      else
        puts "Error Save Customer - Pedido #{id}"
      end
    else
      puts "Pedido #{id} já cadastrado"
    end
  end

  def self.save_name_age
    (1..4).each do |i|
      custom_uri = "https://purchasestore.com.br/ws/wspedidos.json?data_inicio=2020-08-01&status=cancelado&page=#{i}"
      @order_page = Requests::Order.new(custom_uri: custom_uri).call

      @order_page['result'].each do |order_page|
        SimploClient.create(name: order_page['Wspedido']['cliente_razaosocial'],
                            age: Time.now.year - Time.parse(order_page['Wspedido']['cliente_data_nascimento']).year,
                            order_date: Time.parse(order_page['Wspedido']['data_pedido']))
      rescue ArgumentError
        puts 'erro'
      end
    end
  end
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
