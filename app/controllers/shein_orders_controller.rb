# app/controllers/shein_orders_controller.rb

class SheinOrdersController < ApplicationController
  before_action :set_shein_order, only: [:show, :edit, :update, :destroy]

  def index
    @shein_orders = SheinOrder.where("data ->> 'Status do pedido' IN (?)", ['A ser coletado pela SHEIN', 'Pendente', 'Para ser enviado'])
                              .order(Arel.sql("data ->> 'Limite de tempo para coletar' ASC"))
  end
  
  def show
  end
  
  def new
    @shein_order = SheinOrder.new
  end
  
  def create
    @shein_order = SheinOrder.new(shein_order_params)
    if @shein_order.save
      redirect_to @shein_order, notice: 'Order was successfully created.'
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @shein_order.update(shein_order_params)
      redirect_to @shein_order, notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @shein_order.destroy
    redirect_to shein_orders_url, notice: 'Order was successfully destroyed.'
  end

  def upload; end
  
  def import
    file = params[:file]
    if file.present?
      SheinOrder.import_from_file(file)
      redirect_to shein_orders_path, notice: "Orders have been processed."
    else
      redirect_to upload_shein_orders_path, alert: "Please select a valid file."
    end
  end
  
  private
  
  def set_shein_order
    @shein_order = SheinOrder.find(params[:id])
  end
  
  def shein_order_params
    params.require(:shein_order).permit(data: {})
  end
end
