class CurrentDoneBlingOrderItemJob < ApplicationJob
  queue_as :default
  DONE_STATUSES = [BlingOrderItem::Status::CHECKED, BlingOrderItem::Status::VERIFIED].freeze

  attr_accessor :account_id

  def perform(account_id)
    options = { dataInicial: (Date.today - 2.day).strftime('%Y-%m-%d'),
                dataFinal: Date.today.strftime('%Y-%m-%d') }
    @account_id = account_id
    begin
      DONE_STATUSES.each do |status|
        orders = Services::Bling::Order.call(order_command: 'find_orders', tenant: account_id,
                                             situation: status, options: options)
        orders = orders['data']

        create_orders(orders)
      end
    rescue StandardError => e
      Rails.logger.error(e.message)
    end
  end

  private

  def list_status_situation
    BlingOrderItem::Status::ALL
  end

  def fetch_order_data(order_id)
    Services::Bling::FindOrder.call(id: order_id, order_command: 'find_order',
                                    tenant: account_id)
  end

  def create_orders(orders)
    orders.each do |order_data|
      order_id = order_data['id']

      if BlingOrderItem.exists?(bling_order_id: order_id)
        bling_order_items = BlingOrderItem.where(bling_order_id: order_id)
        if order_data['situacao']['id'] != bling_order_items[0].situation_id
          bling_order_items.each do |bling_order_item|
            bling_order_item.update(situation_id: order_data['situacao']['id'])
          end
        end
        next # Skip to the next order
      end

      fetched_order_data = fetch_order_data(order_id)
      begin
        fetched_order_data['data']['itens']
      rescue
        next
      end

      fetched_order_data['data']['itens'].each do |item_data|
        BlingOrderItem.create!(
          bling_order_id: order_id,
          codigo: item_data['codigo'],
          unidade: item_data['unidade'],
          quantidade: item_data['quantidade'],
          desconto: item_data['desconto'],
          valor: item_data['valor'],
          aliquotaIPI: item_data['aliquotaIPI'],
          descricao: item_data['descricao'],
          descricaoDetalhada: item_data['descricaoDetalhada'],
          situation_id: fetched_order_data['data']['situacao']['id'],
          store_id: fetched_order_data['data']['loja']['id'],
          date: fetched_order_data['data']['data']
        )
      end
    end
  end
end
