class OrderItemsJob < ApplicationJob
  queue_as :default
  retry_on StandardError, attempts: 5, wait: :exponentially_longer

  def perform(record)
    return unless record.items.empty?

    account_id = record.account_id
    items_attributes = []
    order = Services::Bling::FindOrder.call(id: record.bling_order_id, order_command: 'find_order', tenant: account_id)
    raise StandardError if order['error'].present?

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
