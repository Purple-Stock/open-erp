# frozen_string_literal: true

class ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!, only: %i[index_defer tags_index_defer]
  before_action :set_product, only: %i[show edit update destroy destroy_from_index]
  include Pagy::Backend
  include ActionView::RecordIdentifier
  # GET /products
  # GET /products.json
  def index
    products = Product.includes(:category)
                      .where(account_id: current_tenant)
                      .order('created_at DESC')

    if params[:search].present?
      search_term = "%#{params[:search]}%"
      products = products.where("name ILIKE ? OR sku ILIKE ?", search_term, search_term)
    end

    @pagy, @products = pagy(products)
  end

  def index_defer
    search_value_params = params.dig(:search, :value)

    @pagy, @products = pagy(Product.datatable_filter(search_value_params, datatable_searchable_columns)
                                   .includes(:purchase_products, :sale_products, :category)
                                   .where(account_id: current_tenant),
                            page: (params[:start].to_i / params[:length].to_i + 1),
                            items: params[:length].to_i)

    order_params = params.dig(:order, :'0')
    @products = @products.datatable_order(order_params[:column].to_i, order_params[:dir])

    options = {}
    options[:meta] = {
      draw: params['draw'].to_i,
      recordsTotal: Product.datatable_filter(search_value_params,
                                             datatable_searchable_columns).count,
      recordsFiltered: Product.datatable_filter(search_value_params,
                                                datatable_searchable_columns).count
    }

    render json: ProductSerializer.new(@products, options).serializable_hash
  end

  def tags_index_defer
    @products = Product.includes(:purchase_products, :sale_products, :category).where(active: true)
    render json: ProductSerializer.new(@products).serializable_hash
  end

  # GET /products/1
  # GET /products/1.json
  def show; end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit; end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Produto criado.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html do
          flash.now[:alert] = ErrorDecorator.new(@product.errors).full_messages
          render :new, status: :unprocessable_entity
        end
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Produto alterado.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    if @product.destroy
      respond_to do |format|
        format.html { redirect_to products_url, notice: 'Produto deletado.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html do
          flash.now[:alert] = @product.errors.full_messages
          render :show, status: :unprocessable_entity
        end
        format.json { head :unprocessable_entity }
      end
    end
  end

  def destroy_from_index
    if @product.destroy
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove(dom_id(@product)) }
      end
    end
  end

  def duplicate
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product != nil? && Services::Product::Duplicate.call(product: @product)
        format.html { redirect_to products_path, notice: 'Cópia Produto feito com sucesso.' }
      else
        flash[:alert] = 'Erro, tente novamente'
      end
    end
  end

  def update_active
    @product = Product.find(params[:id])

    respond_to do |format|
      if Services::Product::UpdateStatus.call(product: @product)
        information_active = @product.active ? 'Ativado' : 'Desativado'
        format.html { redirect_to products_path, notice: "#{@product.name} foi #{information_active}." }
      else
        flash[:alert] = @product.errors.full_messages
        format.html { redirect_to products_path }
      end
    end
  end

  def download_qr_code
    @product = Product.find(params[:id])
    qr_code_data_url = Services::Product::GenerateQrCode.new(product: @product).call
    
    # Convert data URL to binary
    png_data = Base64.decode64(qr_code_data_url.split(',')[1])
    
    send_data png_data, 
      type: 'image/png', 
      disposition: 'attachment', 
      filename: "#{@product.name}_qr_code.png"
  end

  def scan_qr_code
    # Just renders the view with the QR scanner
  end

  def update_stock_from_qr
    @product = Product.find(params[:id])
    quantity = params[:quantity].to_i

    begin
      ActiveRecord::Base.transaction do
        # Create a new stock record or update existing
        if @product.stock.nil?
          @product.create_stock(quantity: quantity)
        else
          @product.stock.update!(quantity: quantity)
        end

        render json: { success: true, message: 'Stock updated successfully' }
      end
    rescue StandardError => e
      render json: { success: false, error: e.message }, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.require(:product).permit(
      :name, :price, :bar_code, :highlight, :account_id,
      :category_id, :active, :image, :custom_id, :sku, :extra_sku,
      :number_of_pieces_per_fabric_roll
    )
  end

  def datatable_searchable_columns
    { '0' => { 'searchable' => true }, '1' => { 'searchable' => true } }
  end
end
