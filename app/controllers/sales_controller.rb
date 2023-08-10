# frozen_string_literal: true

class SalesController < ApplicationController
  before_action :set_sale, only: %i[show edit update destroy]
  include Pagy::Backend
  # GET /sales
  # GET /sales.json
  def index
    sales = Sale.includes(:sale_products,
                          :customer).where(account_id: current_tenant).references(:customers).order(created_at: :desc)
    @pagy, @sales = pagy(sales)
  end

  def index_defer
    @sales = Sale.includes(:sale_products,
                           :customer).where(account_id: current_tenant).references(:customers).order(created_at: :desc)
    @pagy, @sales = pagy(@sales.datatable_filter(params['search']['value'], datatable_searchable_columns),
                         page: (params[:start].to_i / params[:length].to_i + 1),
                         items: params[:length].to_i)
    @sales = @sales.datatable_order(params['order']['0']['column'].to_i,
                                    params['order']['0']['dir'])
    options = {}
    options[:meta] = {
      draw: params['draw'].to_i,
      recordsTotal: @sales.size,
      recordsFiltered: @sales.size
    }
    render json: SaleSerializer.new(@sales, options).serializable_hash
  end

  # GET /sales/1
  # GET /sales/1.json
  def show; end

  # GET /sales/new
  def new
    @sale = Sale.new
    @sale_products = @sale.sale_products.build
  end

  # GET /sales/1/edit
  def edit; end

  # POST /sales
  # POST /sales.json
  def create
    @sale = Sale.new(sale_params)
    calc_value
    respond_to do |format|
      if @sale.save
        format.html { redirect_to @sale, notice: t('sales.created') }
        format.json { render :show, status: :created, location: @sale }
      else
        format.html { render :new }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales/1
  # PATCH/PUT /sales/1.json
  def update
    respond_to do |format|
      if @sale.update(sale_params)
        calc_value
        format.html { redirect_to @sale, notice: t('sales.updated') }
        format.json { render :show, status: :ok, location: @sale }
      else
        format.html { render :edit }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1
  # DELETE /sales/1.json
  def destroy
    @sale.destroy
    respond_to do |format|
      format.html { redirect_to sales_url, notice: t('sales.destroyed') }
      format.json { head :no_content }
    end
  end

  def insert_orders; end

  def save_orders
    number_orders = params[:number_orders].delete(' ').split(',')
    number_orders.each do |no|
      Sale.integrate_orders(no, params[:sale][:origin])
    end
    respond_to do |format|
      format.html { redirect_to sales_url, notice: 'Venda Integrada com sucesso.' }
    end
  end

  def sales_checkout; end

  def verify_sales
    content = params[:content]

    # Split the content by newlines to get an array of lines
    lines = content.split("\n")

    # Initialize an empty array to collect results or errors
    results = []
    byebug
    lines.each do |line|

      service = Services::Bling::UpdateOrderSituation.new(id: line, tenant: current.tenant.id, new_situation_id: new_situation_id)
      result = service.call

      # Store the result or an error message for this line
      if result.is_a?(Hash) && result["situacao"]
        results << "Line #{line}: Order situation updated successfully!"
      else
        results << "Line #{line}: Failed to update order situation - #{result}"
      end
    end

    # Decide what to do with the results
    # Here, I'm simply joining them into a string and redirecting to the root path with a notice.
    # Depending on your application's needs, you might want to render a view to display these results, or handle them differently.
    redirect_to root_path, notice: results.join("\n")
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sale
    @sale = Sale.find(params[:id])
  end

  def calc_value
    value = 0
    @sale.sale_products.each do |sale_product|
      value += sale_product.value
    end
    value -= @sale.discount if @sale.discount.present?
    @sale.update(value: value.round(2))
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sale_params
    params['sale']['account_id'] = current_tenant.id
    params.require(:sale).permit(:value, :exchange, :discount, :percentage, :online, :created_at, :disclosure, :customer_id,
                                 :payment_type, :store_sale, :total_exchange_value, :account_id,
                                 sale_products_attributes: %i[id product_id quantity account_id value _destroy])
  end

  def datatable_searchable_columns
    { '0' => { 'searchable' => true }, '1' => { 'searchable' => true } }
  end
end
