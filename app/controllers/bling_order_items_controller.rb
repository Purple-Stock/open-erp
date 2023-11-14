class BlingOrderItemsController < ApplicationController
  def index
    @bling_shein_orders = BlingOrderItem
                           .select('bling_order_items.*, shein_orders.data ->> \'Pacote do comerciante\' as pacote_do_comerciante, shein_orders.data ->> \'Número do pedido\' as numero_do_pedido, shein_orders.data ->> \'Status do produto\' as status_do_produto')
                           .joins('LEFT JOIN shein_orders ON bling_order_items.marketplace_code_id = shein_orders.data->>\'Número do pedido\'')
                           .where(store_id: "204219105")
                           .order(:situation_id)
  end
end
