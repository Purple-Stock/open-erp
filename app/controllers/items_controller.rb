class ItemsController < ApplicationController
  def update_status
    @item = Item.find(params[:id])
    case params[:status]
    when 'resolved'
      @item.resolve!
    when 'unresolved'
      @item.unresolve!
    end
    redirect_back(fallback_location: show_pending_orders_path, notice: 'Status atualizado com sucesso.')
  end
end