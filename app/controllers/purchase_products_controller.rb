# frozen_string_literal: true

class PurchaseProductsController < ApplicationController
  before_action :set_purchase_product, only: %i[show edit update destroy]
  include Pagy::Backend
  # GET /purchase_products
  # GET /purchase_products.json
  def index
    purchase_products = PurchaseProduct.includes(:product).references(:products).where(account_id: current_tenant)
    @pagy, @purchase_products = pagy(purchase_products)
  end

  def index_defer
    @purchase_products = PurchaseProduct.includes(:product).references(:products).where(account_id: current_tenant)
    @purchased_products_filtered = @purchase_products.filter_products(@purchase_products, params['search']['value'])
    @pagy, @purchase_products = pagy(@purchased_products_filtered,
                                     page: (params[:start].to_i / params[:length].to_i + 1),
                                     items: params[:length].to_i)
    @purchase_products = @purchase_products.datatable_order(params['order']['0']['column'].to_i,
                                                            params['order']['0']['dir'])
    options = {}
    options[:meta] = {
      draw: params['draw'].to_i,
      recordsTotal: @purchased_products_filtered.size,
      recordsFiltered: @purchased_products_filtered.size
    }
    render json: PurchaseProductSerializer.new(@purchase_products, options).serializable_hash
  end

  # GET /purchase_products/1
  # GET /purchase_products/1.json
  def show; end

  # GET /purchase_products/new
  def new
    @purchase_product = PurchaseProduct.new
  end

  # GET /purchase_products/new_code_reader
  def new_code_reader
    @purchase_product = PurchaseProduct.new
  end

  # GET /purchase_products/1/edit
  def edit; end

  # POST /purchase_products
  # POST /purchase_products.json
  def create
    @purchase_product = PurchaseProduct.new(purchase_product_params)

    respond_to do |format|
      if @purchase_product.save
        format.html { redirect_to @purchase_product, notice: 'Entrada de estoque criado.' }
        format.json { render :show, status: :created, location: @purchase_product }
      else
        format.html { render :new }
        format.json { render json: @purchase_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchase_products/1
  # PATCH/PUT /purchase_products/1.json
  def update
    respond_to do |format|
      if @purchase_product.update(purchase_product_params)
        format.html { redirect_to @purchase_product, notice: 'Entrada de estoque alterado.' }
        format.json { render :show, status: :ok, location: @purchase_product }
      else
        format.html { render :edit }
        format.json { render json: @purchase_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_products/1
  # DELETE /purchase_products/1.json
  def destroy
    @purchase_product.destroy
    respond_to do |format|
      format.html { redirect_to purchase_products_url, notice: 'Entrada de estoque deletado.' }
      format.json { head :no_content }
    end
  end

  def stock_transfer; end

  def save_stock_transfer
    begin
      PurchaseProduct.create(product_id: params['product_id'], quantity: -params['quantity'].to_i,
                             store_entrance: params['stock_transfer']['origin'])
      PurchaseProduct.create(product_id: params['product_id'], quantity: params['quantity'].to_i,
                             store_entrance: params['stock_transfer']['destiny'])
    rescue ArgumentError
      Rails.logger.debug 'erro'
    end
    respond_to do |format|
      format.html { redirect_to stock_transfer_path, notice: 'Transferência Concluída.' }
      format.json { head :no_content }
    end
  end

  def inventory_view; end

  def save_inventory
    product = Product.find(params['product_id'])
    PurchaseProduct.inventory_quantity(product.custom_id, params['quantity'].to_i, params['inventory']['destiny'])
    respond_to do |format|
      format.html { redirect_to stock_transfer_path, notice: 'Inventário Concluído.' }
    end
  rescue ArgumentError
    Rails.logger.debug 'erro'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_purchase_product
    @purchase_product = PurchaseProduct.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def purchase_product_params
    params['purchase_product']['account_id'] = current_tenant.id
    params.require(:purchase_product).permit(:quantity, :value, :product_id, :purchaseId, :created_at,
                                             :store_entrance, :account_id)
  end

  def datatable_searchable_columns
    { '0' => { 'searchable' => true }, '1' => { 'searchable' => true } }
  end
end
