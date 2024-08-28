# app/controllers/productions_controller.rb

class ProductionsController < ApplicationController
  before_action :set_production, only: [:show, :edit, :update, :destroy]

  def index
    @productions = Production.includes(:tailor, production_products: :product).all
  end

  def show
  end

  def new
    @production = Production.new
    @production.production_products.build
    @tailors = Tailor.all
  end

  def create
    @production = Production.new(production_params)
    if @production.save
      redirect_to @production, notice: 'Production was successfully created.'
    else
      @tailors = Tailor.all
      render :new
    end
  end

  def edit
    @tailors = Tailor.all
  end

  def update
    if @production.update(production_params)
      redirect_to @production, notice: 'Production was successfully updated.'
    else
      @tailors = Tailor.all
      render :edit
    end
  end

  def destroy
    @production.destroy
    redirect_to productions_url, notice: 'Production was successfully destroyed.'
  end

  private

  def set_production
    @production = Production.find(params[:id])
  end

  def production_params
    params.require(:production).permit(
      :tailor_id, :cut_date, :delivery_date, :consider,
      production_products_attributes: [:id, :product_id, :quantity, :_destroy]
    )
  end
end