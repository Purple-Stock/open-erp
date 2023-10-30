class SheinDashboardsController < ApplicationController

  def index
    finance_per_status
  end

  private

  def finance_per_status
    @pendings = SheinOrder.where("data ->> 'Status do pedido' = ?", "Pendente")
    @to_be_colected = SheinOrder.where("data ->> 'Status do pedido' = ?", "A ser coletado pela SHEIN")
    @to_be_sent = SheinOrder.where("data ->> 'Status do pedido' = ?", "A ser enviado pela SHEIN")
    @sent = SheinOrder.where("data ->> 'Status do pedido' = ?", "Enviado")
  end
end
