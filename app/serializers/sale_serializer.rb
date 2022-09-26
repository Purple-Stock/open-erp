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
class SaleSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :order_code

  attribute :name do |object|
    object.customer.name.capitalize
  end

  attribute :discount do |object|
    "R$#{object.discount.to_s.gsub('.', ',')}"
  end

  attribute :percentage do |object|
    "#{object.percentage}%"
  end

  attribute :online do |object|
    if object.online
      'Sim'
    else
      'Não'
    end
  end

  attribute :exchange do |object|
    if object.exchange
      'Sim'
    else
      'Não'
    end
  end

  attribute :disclosure do |object|
    if object.disclosure
      'Sim'
    else
      'Não'
    end
  end

  attribute :value do |object|
    "R$#{object.value.to_s.gsub('.', ',')}"
  end

  attribute :created_at do |object|
    object.created_at.strftime('%d/%m/%Y %H:%M')
  end
end
