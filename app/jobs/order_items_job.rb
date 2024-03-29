class OrderItemsJob < ApplicationJob
  queue_as :items

  def perform(bling_order_id)
    record = BlingOrderItem.find_by(bling_order_id:)
    account_id = record.account_id
    items_attributes = []
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

    record.items.build(items_attributes)
    record.save!
  end
end
