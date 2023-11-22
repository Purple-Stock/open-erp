# app/views/api/v1/checkout/orders/find_order.json.jbuilder

json.set! :data do
  # BlingOrderItem attributes
  json.extract! @bling_shein_orders, :bling_id, :bling_order_id

  # Additional fields from shein_orders
  json.store_name BlingOrderItem::STORE_ID_NAME_KEY_VALUE[@bling_shein_orders.store_id]
  json.merchant_package @bling_shein_orders.pacote_do_comerciante
  json.order_number @bling_shein_orders.numero_do_pedido
  json.shein_status @bling_shein_orders.status_do_produto
  json.bling_status BlingOrderItem::STATUS_NAME_KEY_VALUE[@bling_shein_orders.situation_id]
  json.account_id @bling_shein_orders.account_id
end
