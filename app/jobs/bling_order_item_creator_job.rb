class BlingOrderItemCreatorJob < ApplicationJob
  queue_as :default
  attr_accessor :account_id

  def perform(account_id)
    @account_id = account_id
    create_in_progress_order_items
    create_checked_order_items
    create_pending_order_items
    create_printed_order_items
  end

  private

  def create_in_progress_order_items
    in_progress = Services::Bling::Order.call(order_command: 'find_orders', tenant: account_id,
                                              situation: 15)

    @in_progress_orders = in_progress['data']
    return if @in_progress_orders.blank?

    create_orders(@in_progress_orders)
  end

  def create_checked_order_items
    checked = Services::Bling::Order.call(order_command: 'find_orders', tenant: account_id,
                                          situation: 24)

    @checked_orders = checked['data']
    return if @checked_orders.blank?

    create_orders(@checked_orders)
  end

  def create_pending_order_items
    pending = Services::Bling::Order.call(order_command: 'find_orders', tenant: account_id,
                                          situation: 94_871)

    @pending_orders = pending['data']
    return if @pending_orders.blank?

    create_orders(@pending_orders)
  end

  def create_printed_order_items
    printed = Services::Bling::Order.call(order_command: 'find_orders', tenant: account_id,
                                          situation: 95_745)

    @printed_orders = printed['data']
    return if @printed_orders.blank?

    create_orders(@printed_orders)
  end

  def create_verified_order_items
    verified = Services::Bling::Order.call(order_command: 'find_orders', tenant: account_id,
                                          situation: 101_065)

    @verified_orders = verified['data']
    return if @verified_orders.blank?

    create_orders(@verified_orders)
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
