# frozen_string_literal: true

class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show edit update destroy]
  include Pagy::Backend
  # GET /customers
  # GET /customers.json
  def index
    customers = Customer.where(account_id: current_tenant)
    @pagy, @customers = pagy(customers)
  end

  # GET /customers/1
  # GET /customers/1.json
  def show; end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit; end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, notice: t('customers.created') }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to @customer, notice: t('customers.updated') }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: t('customers.deleted') }
      format.json { head :no_content }
    end
  end

  def import
    import = ImportCustomerCSV.new(file: params[:file]) # file is send by form
    import.run!
    if import.report.success?
      redirect_to customers_path, success: 'Arquivo importado com sucesso!'
    else
      redirect_to customers_path, success: "Não foi possível importar o arquivo: #{import.report.message}"
    end  
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_customer
    @customer = Customer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def customer_params
    params['customer']['account_id'] = current_tenant.id
    params.require(:customer).permit(:name, :email, :cellphone, :phone, :cpf, :account_id)
  end
end
