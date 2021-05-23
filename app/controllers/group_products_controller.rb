class GroupProductsController < ApplicationController
  before_action :set_group_product, only: [:show, :edit, :update, :destroy]

  # GET /group_products
  # GET /group_products.json
  def index
    @group_products = GroupProduct.all
  end

  # GET /group_products/1
  # GET /group_products/1.json
  def show
  end

  # GET /group_products/new
  def new
    @group_product = GroupProduct.new
  end

  # GET /group_products/1/edit
  def edit
  end

  # POST /group_products
  # POST /group_products.json
  def create
    @group_product = GroupProduct.new(group_product_params)

    respond_to do |format|
      if @group_product.save
        format.html { redirect_to @group_product, notice: 'Group product was successfully created.' }
        format.json { render :show, status: :created, location: @group_product }
      else
        format.html { render :new }
        format.json { render json: @group_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /group_products/1
  # PATCH/PUT /group_products/1.json
  def update
    respond_to do |format|
      if @group_product.update(group_product_params)
        format.html { redirect_to @group_product, notice: 'Group product was successfully updated.' }
        format.json { render :show, status: :ok, location: @group_product }
      else
        format.html { render :edit }
        format.json { render json: @group_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /group_products/1
  # DELETE /group_products/1.json
  def destroy
    @group_product.destroy
    respond_to do |format|
      format.html { redirect_to group_products_url, notice: 'Group product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group_product
      @group_product = GroupProduct.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_product_params
      params.fetch(:group_product, {})
    end
end
