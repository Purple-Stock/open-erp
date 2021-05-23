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
    object.created_at.strftime("%d/%m/%Y %H:%M")
  end

end
