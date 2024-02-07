class BlingOrderItemsController < ApplicationController
  before_action :default_initial_date, :disable_initial_date, :default_final_date
  include Pagy::Backend
  inherit_resources
  decorates_assigned :bling_order_item

  def update
    update! do |success, failure|
      success.html do
        flash[:notice] = t('flash.success.update', model: bling_order_item.class_name)
        redirect_to resource
      end
      failure.html do
        flash.now[:alert] = t('flash.failure.update', model: bling_order_item.class_name)
        render resource, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if resource.deleted_at_bling!
      redirect_to resource, notice: 'A verificar Pedido de compra junto à Bling'
    else
      redirect_to resource, alert: 'Pedido já em processo de deletar!'
    end
  end

  protected

  def collection
    @default_status_filter = params['status'] || BlingOrderItemStatus::ALL
    @default_store_filter = params['store_id'] || BlingOrderItemStore::ALL

    bling_order_items = BlingOrderItem.where(account_id: current_tenant)
                                      .by_status(@default_status_filter)
                                      .date_range(@default_initial_date, @default_final_date)
                                      .by_store(@default_store_filter)
    @pagy, @bling_order_items = pagy(bling_order_items)
  end

  def permitted_params
    params.permit(bling_order_item: %i[situation_id])
  end

  private

  def default_initial_date
    @default_initial_date = params['initial_date'] || Date.today
  end

  # Dashboard has links to each status. From its point of view, it does not
  # meter the initial_date filter since dashboard wants to see all period.
  def disable_initial_date
    @default_initial_date = nil if params['disable_initial_date'].present?
  end

  def default_final_date
    @default_final_date = params['final_date'] || Date.today
  end
end
