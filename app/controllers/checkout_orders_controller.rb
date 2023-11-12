class CheckoutOrdersController < ApplicationController

  def index
    @combined_order_data ||= []
  end

  def process_file
    if params[:document].present?
      file_path = params[:document].tempfile
      package_codes = File.readlines(file_path).map(&:chomp)
    elsif params[:text_block].present?
      package_codes = params[:text_block].split("\n").map(&:chomp)
    else
      flash.now[:alert] = "Please provide a package code list either as text or file."
      @shein_orders = []
      render :index and return
    end

    @shein_orders = package_codes.filter_map do |code|
      SheinOrder.find_by("data ->> 'Pacote do comerciante' = ?", code)
    end

    combined_order_data = []

    @shein_orders.each do |shein_order|
      # Extract the package code and order number from the order data
      package_code = shein_order.data['Pacote do comerciante']
      order_number = shein_order.data['Número do pedido']
      shein_status = shein_order.data['Status do produto']
  
      # Find the corresponding BlingOrderItem by marketplace_code_id
      bling_order_item = BlingOrderItem.find_by(marketplace_code_id: order_number)
  
      # Create a hash with the combined data
      combined_order = {
        order_number: order_number,
        package_code: package_code,
        bling_order_item: bling_order_item,
        shein_status: shein_status
      }
  
      # Add the combined order hash to the array
      combined_order_data << combined_order
    end
  
    # Now @combined_order_data contains all the combined data objects
    @combined_order_data = combined_order_data
  
    render :index
  end

  def update_selected_orders
    #byebug
    selected_orders = params[:selected_orders]
    id_situacao = params[:id_situacao]
    #byebug
    # Logic to update orders via Bling API
    #selected_orders.each do |order_id|
      Services::Bling::UpdateOrderStatus.call(
        tenant: current_tenant.id,
        order_ids: params[:selected_orders],
        new_status: params[:id_situacao]
      )
    #end

    # Redirect or render with a success/failure message
    redirect_to checkout_orders_path, notice: 'Orders updated successfully'
  end

  private

  def checkout_order_params
    params.require(:checkout_order).permit(:text_block, :document)
  end

end
