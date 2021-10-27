# frozen_string_literal: true

class ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!, only: %i[index_defer tags_index_defer]
  before_action :set_product, only: %i[show edit update destroy]
  include Pagy::Backend
  # GET /products
  # GET /products.json
  def index; end

  def index_defer
    search_value_params = params.dig(:search, :value)

    @pagy, @products = pagy(Product.datatable_filter(search_value_params, datatable_searchable_columns)
                                   .includes(:purchase_products, :sale_products, :category)
                                   .where(account_id: current_tenant),
                            page: (params[:start].to_i / params[:length].to_i + 1),
                            items: params[:length].to_i
                           )

    order_params = params.dig(:order, :'0')
    @products = @products.datatable_order(order_params.dig(:column).to_i, order_params.dig(:dir))

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
        format.html { render :new }
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
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Produto deletado.' }
      format.json { head :no_content }
    end
  end

  def duplicate
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product != nil?
        product_clone = @product.dup
        product_clone.name = "#{product_clone.name} Cópia"
        product_clone.save
        format.html { redirect_to products_path, notice: 'Cópia Produto feito com sucesso.' }
      else
        flash[:alert] = 'Erro, tente novamente'
      end
    end
  end

  def update_active
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_active!
        information_active = @product.active ? 'Ativado' : 'Desativado'
        format.html { redirect_to products_path, notice: "#{@product.name} foi #{information_active}." }
      else
        flash[:alert] = @product.errors.full_messages
        format.html { redirect_to products_path }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params['product']['account_id'] = current_tenant.id
    params.require(:product).permit(:name, :price, :bar_code, :highlight, :account_id,
                                    :category_id, :active, :image, :custom_id, :sku, :extra_sku)
  end

  def datatable_searchable_columns
    { '0' => { 'searchable' => true }, '1' => { 'searchable' => true } }
  end
end
