class SheinDashboardsController < ApplicationController

  def index
    finance_per_status
    @finance_data = FinanceDatum.order(:date)
  end

  private

  def finance_per_status
    @pendings = SheinOrder.where("data ->> 'Status do pedido' = ?", "Pendente")
    @to_be_colected = SheinOrder.where("data ->> 'Status do pedido' = ?", "Para ser coletado por SHEIN")
    @to_be_sent = SheinOrder.where("data ->> 'Status do pedido' = ?", "Para ser enviado por SHEIN")
    @sent = SheinOrder.where("data ->> 'Status do pedido' = ?", "Enviado")
  end
end
