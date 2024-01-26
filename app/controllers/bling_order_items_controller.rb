class BlingOrderItemsController < ApplicationController
  include Pagy::Backend
  inherit_resources

  protected

  def collection
    @default_status_filter = params['status']
    @default_initial_date = params['initial_date'] || Date.today
    @default_final_date = params['final_date'] || Date.today
    @default_store_filter = params['store_id'] || BlingOrderItemStore::ALL

    bling_order_items = BlingOrderItem.where(account_id: current_tenant)
                                      .by_status(@default_status_filter)
                                      .date_range(@default_initial_date, @default_final_date)
                                      .by_store(@default_store_filter)
    @pagy, @bling_order_items = pagy(bling_order_items)
  end
end
