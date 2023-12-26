class ProductionsController < ApplicationController
  before_action :set_production, only: [:show, :edit, :update, :destroy]
  before_action :set_tailor_options, only: [:new, :edit, :create, :update]

  def index
    @productions = Production.all
  end

  def show
  end

  def new
    @production = Production.new
    @production.production_products.build
  end

  def edit
  end

  def create
    @production = Production.new(production_params)
    if @production.save
      redirect_to @production, notice: 'Production was successfully created.'
    else
      render :new
    end
  end

  def update
    if @production.update(production_params)
      redirect_to @production, notice: 'Production was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    begin      
      ProductionProduct.where(production_id: @production.id).destroy_all
      @production.destroy
      respond_to do |format|
        format.html { redirect_to productions_path, notice: 'Produção deletado.' }
        format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@production)) }
      end
    rescue ActiveRecord::InvalidForeignKey
      # Handle invalid foreign key by raising a custom error message
      raise "Can't delete production because it has associated records"
    end
  end

  private

    def set_production
      @production = Production.find(params[:id])
    end

    def production_params
      params.require(:production).permit(:cut_date, :deliver_date, :quantity, :tailor_id, :consider, production_products_attributes: [:id, :product_id, :quantity, :_destroy])
    end

    def set_tailor_options
      @tailors = Tailor.all
    end
end
