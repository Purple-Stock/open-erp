class WarehousesController < ApplicationController
  before_action :set_warehouse, only: [:show, :edit, :update, :destroy]

  def index
    @warehouses = Warehouse.all
  end

  def show
  end

  def new
    @warehouse = Warehouse.new
  end

  def create
    @warehouse = Warehouse.new(warehouse_params)

    if @warehouse.save
      redirect_to @warehouse, notice: 'Warehouse was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @warehouse.update(warehouse_params)
      redirect_to @warehouse, notice: 'Warehouse was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @warehouse.destroy
    redirect_to warehouses_url, notice: 'Warehouse was successfully destroyed.'
  end

  private

  def set_warehouse
    @warehouse = Warehouse.find(params[:id])
  end

  def warehouse_params
    params.require(:warehouse).permit(:bling_id, :description, :status, :is_default, :ignore_balance, :account_id)
  end
end