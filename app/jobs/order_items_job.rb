class OrderItemsJob < ApplicationJob
  queue_as :items

  def perform(bling_order_id)
    record = BlingOrderItem.find_by(bling_order_id:)
    account_id = record.account_id
    items_attributes = []
    label_attributes = []
    order = Services::Bling::FindOrder.call(id: bling_order_id, order_command: 'find_order', tenant: account_id)
    raise(StandardError, order['error']) if order['error'].present?

    order['data']['itens'].each do |item|
      items_attributes << {
        sku: item['codigo'],
        unity: item['unidade'],
        quantity: item['quantidade'],
        discount: item['desconto'],
        value: item['valor'],
        ipi_tax: item['aliquotaIPI'],
        description: item['descricao'],
        long_description: item['descricaoDetalhada'],
        product_id: item['produto']['id'],
        account_id:
      }
    end

    label = order['data']['transporte']['etiqueta']

    label_attributes << {
      name: label['nome'],
      address: label['endereco'],
      number: label['numero'],
      complement: label['complemento'],
      city: label['municipio'],
      state: label['uf'],
      zip_code: label['cep'],
      neighborhood: label['bairro'],
      country_name: label['nomePais'],
      account_id:
    }

    record.items.build(items_attributes)
    record.build_localization(label_attributes.first)
    record.save!
  end
end
