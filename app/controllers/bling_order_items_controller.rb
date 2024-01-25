class BlingOrderItemsController < ApplicationController
  include Pagy::Backend
  inherit_resources

  protected

  def collection
    @default_status_filter = params['status']

    bling_order_items = BlingOrderItem.where(account_id: current_tenant).by_status(@default_status_filter)
    @pagy, @bling_order_items = pagy(bling_order_items)
  end
end
