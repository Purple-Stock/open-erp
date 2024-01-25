class BlingOrderItemsController < ApplicationController
  include Pagy::Backend
  inherit_resources

  protected

  def collection
    @default_status_filter = params['status']
    @default_situation_balance_filter = params['balance_situation']

    bling_order_items = BlingOrderItem.where(account_id: current_tenant)
    @pagy, @bling_order_items = pagy(bling_order_items)
  end
end
