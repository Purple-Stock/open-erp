# frozen_string_literal: true

# Move the logic of the views/bling_order_items/* to here.
module BlingOrderItemsHelper
  EDIT_BLING_ORDER_URL = 'https://www.bling.com.br/b/vendas.php#edit/'

  def link_to_external_bling_order(bling_order_id)
    link_to bling_order_id, EDIT_BLING_ORDER_URL + bling_order_id, target: '_blank', rel: 'noopener'
  end
end
