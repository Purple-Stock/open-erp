module HomeHelper
  def absent_stores(grouped_order_items)
    present_stores = grouped_order_items.keys
    all_stores = BlingOrderItem::STORE_ID_NAME_KEY_VALUE.keys
    all_stores - present_stores
  end
end