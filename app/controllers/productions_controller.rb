# app/controllers/productions_controller.rb

require 'prawn'
include ActionView::Helpers::NumberHelper

class ProductionsController < ApplicationController
  before_action :set_production, only: [:show, :edit, :update, :destroy, :verify]
  before_action :set_tailors, only: [:new, :edit, :create, :update]

  def index
    @productions = Production.includes(:tailor, production_products: :product).all

    if params[:tailor_id].present?
      @productions = @productions.where(tailor_id: params[:tailor_id])
    end

    if params[:service_order_number].present?
      @productions = @productions.where("service_order_number LIKE ?", "%#{params[:service_order_number]}%")
    end

    # Add this block for the confirmed filter
    if params[:confirmed].present?
      @productions = @productions.where(confirmed: params[:confirmed] == 'true')
    end

    @productions = @productions.order(service_order_number: :desc)
  end

  def show; end

  def verify
    @production = @account.productions.find(params[:id])
  end

  def new
    @production = Production.new
    @production.production_products.build
    @tailors = Tailor.all
  end

  def create
    @production = Production.new(production_params)
    if @production.save
      redirect_to @production, notice: t('.production_created')
    else
      @tailors = Tailor.all
      flash.now[:alert] = t('.creation_failed')
      logger.error("Failed to create production: #{@production.errors.full_messages}")
    end
  end

  def edit
    @production = Production.find(params[:id])
    @tailors = Tailor.all  # Ensure @tailors is set for the edit view
  end

  def update
    @production = Production.find(params[:id])
    if @production.update!(production_params)
      redirect_to @production, notice: t('.production_updated')
    else
      @tailors = Tailor.all
      render :edit
    end
  end

  def destroy
    if @production.destroy
      redirect_to productions_url, notice: t('.production_destroyed')
    else
      redirect_to productions_url, alert: t('.destruction_failed')
    end
  end

  def missing_pieces
    @productions_with_missing_pieces = Production.includes(:tailor, production_products: :product)
                                                 .where(id: ProductionProduct.select(:production_id)
                                                                             .where('quantity > COALESCE(pieces_delivered, 0) + COALESCE(dirty, 0) + COALESCE(error, 0) + COALESCE(discard, 0)')
                                                                             .where(returned: false))  # Add this line
                                                 .distinct
                                                 .order(cut_date: :desc, service_order_number: :desc)  # Order by cut_date and service_order_number

    if params[:tailor_id].present?
      @productions_with_missing_pieces = @productions_with_missing_pieces.where(tailor_id: params[:tailor_id])
    end

    # Add status filter
    if params[:status].present?
      case params[:status]
      when 'on_time'
        @productions_with_missing_pieces = @productions_with_missing_pieces.where('expected_delivery_date > ?', Date.today)
      when 'late'
        @productions_with_missing_pieces = @productions_with_missing_pieces.where('expected_delivery_date <= ? AND expected_delivery_date IS NOT NULL', Date.today)
      when 'no_date'
        @productions_with_missing_pieces = @productions_with_missing_pieces.where(expected_delivery_date: nil)
      end
    end

    @tailors_summary = calculate_tailors_summary(@productions_with_missing_pieces)

    respond_to do |format|
      format.html
      format.csv { send_data generate_tailors_summary_csv, filename: "tailors_summary_#{Date.today}.csv" }
    end
  end

  def products_in_production_report
    @products_summary = ProductionProduct.joins(:production, :product)
      .where('quantity > COALESCE(pieces_delivered, 0) + COALESCE(dirty, 0) + COALESCE(error, 0) + COALESCE(discard, 0)')
      .group('products.id, products.name')
      .select('products.id, products.name, SUM(quantity) as total_quantity, SUM(quantity - COALESCE(pieces_delivered, 0) - COALESCE(dirty, 0) - COALESCE(error, 0) - COALESCE(discard, 0)) as total_missing')
      .order('total_quantity DESC')  # Change this line to order by total_quantity in descending order

    respond_to do |format|
      format.html
      format.csv { send_data generate_products_in_production_csv, filename: "products_in_production_#{Date.today}.csv" }
    end
  end

  def service_order_pdf
    @production = Production.find(params[:id])
    pdf = Services::Pdf::ServiceOrderPdfGenerator.new(@production).generate
    send_data pdf.render, filename: "service_order_#{@production.service_order_number}.pdf", type: 'application/pdf', disposition: 'inline'
  end

  def payment_order_pdf
    @production = Production.find(params[:id])
    pdf = Services::Pdf::PaymentOrderPdfGenerator.new(@production).generate
    send_data pdf.render, filename: "payment_order_#{@production.service_order_number}.pdf", type: 'application/pdf', disposition: 'inline'
  end

  def unpaid_confirmed
    @unpaid_confirmed_productions = Production.includes(:tailor, production_products: :product)
                                              .where(confirmed: true, paid: false)
                                              .order(cut_date: :desc, service_order_number: :desc)

    @paid_productions = Production.includes(:tailor, production_products: :product)
                                  .where(confirmed: true, paid: true)
                                  .order(payment_date: :desc, service_order_number: :desc)

    if params[:tailor_id].present?
      @unpaid_confirmed_productions = @unpaid_confirmed_productions.where(tailor_id: params[:tailor_id])
      @paid_productions = @paid_productions.where(tailor_id: params[:tailor_id])
    end

    @tailors_summary = calculate_tailors_summary_unpaid(@unpaid_confirmed_productions)

    respond_to do |format|
      format.html
      format.csv { send_data generate_unpaid_confirmed_csv, filename: "unpaid_confirmed_productions_#{Date.today}.csv" }
    end
  end

  private

  def set_production
    @production = Production.find(params[:id])
  end

  def set_tailors
    @tailors = Tailor.all
  end

  def production_params
    params.require(:production).permit(
      :service_order_number, :tailor_id, :cut_date, :expected_delivery_date, :payment_date,
      :notions_cost, :fabric_cost, :observation, :confirmed, :paid,
      production_products_attributes: [:id, :product_id, :quantity, :unit_price, :total_price, :pieces_delivered, :dirty, :error, :discard, :returned, :delivery_date, :_destroy]
    )
  end

  def calculate_tailors_summary(productions)
    summary = productions.each_with_object({}) do |production, summary|
      tailor_id = production.tailor_id
      summary[tailor_id] ||= { productions_count: 0, total_missing_pieces: 0, products: {} }
      summary[tailor_id][:productions_count] += 1

      production.production_products.each do |pp|
        next if pp.returned  # Skip if the product is returned
        missing_pieces = pp.quantity - ((pp.pieces_delivered || 0) + (pp.dirty || 0) + (pp.error || 0) + (pp.discard || 0))
        if missing_pieces > 0
          summary[tailor_id][:total_missing_pieces] += missing_pieces
          summary[tailor_id][:products][pp.product_id] ||= 0
          summary[tailor_id][:products][pp.product_id] += missing_pieces
        end
      end
    end

    # Sort products by missing pieces count (descending order)
    summary.each do |tailor_id, tailor_summary|
      tailor_summary[:products] = tailor_summary[:products].sort_by { |_, count| -count }.to_h
    end

    summary
  end

  def calculate_tailors_summary_unpaid(productions)
    summary = productions.each_with_object({}) do |production, summary|
      tailor_id = production.tailor_id
      summary[tailor_id] ||= { productions_count: 0, total_value: 0, products: {} }
      summary[tailor_id][:productions_count] += 1

      production.production_products.each do |pp|
        summary[tailor_id][:total_value] += pp.total_price if pp.total_price
        summary[tailor_id][:products][pp.product_id] ||= { count: 0, value: 0 }
        summary[tailor_id][:products][pp.product_id][:count] += pp.quantity
        summary[tailor_id][:products][pp.product_id][:value] += pp.total_price if pp.total_price
      end
    end

    summary.each do |tailor_id, tailor_summary|
      tailor_summary[:products] = tailor_summary[:products].sort_by { |_, data| -data[:value] }.to_h
    end

    summary
  end

  def generate_tailors_summary_csv
    require 'csv'

    CSV.generate(headers: true) do |csv|
      csv << ['Tailor Name', 'Total Productions', 'Total Missing Pieces', 'Products with Missing Pieces']

      @tailors_summary.each do |tailor_id, summary|
        tailor = Tailor.find(tailor_id)
        products_summary = summary[:products].map { |product_id, count| "#{Product.find(product_id).name}: #{count}" }.join(', ')
        
        csv << [
          tailor.name,
          summary[:productions_count],
          summary[:total_missing_pieces],
          products_summary
        ]
      end
    end
  end

  def generate_products_in_production_csv
    require 'csv'

    CSV.generate(headers: true) do |csv|
      csv << ['Product Name', 'Total Quantity', 'Total Missing Pieces']

      @products_summary.each do |product|
        csv << [
          product.name,
          product.total_quantity,
          product.total_missing
        ]
      end
    end
  end

  def generate_unpaid_confirmed_csv
    require 'csv'

    CSV.generate(headers: true) do |csv|
      csv << ['Tailor Name', 'Total Productions', 'Total Value', 'Products']

      @tailors_summary.each do |tailor_id, summary|
        tailor = Tailor.find(tailor_id)
        products_summary = summary[:products].map { |product_id, data| "#{Product.find(product_id).name}: #{data[:count]} (#{number_to_currency(data[:value])})" }.join(', ')
        
        csv << [
          tailor.name,
          summary[:productions_count],
          number_to_currency(summary[:total_value]),
          products_summary
        ]
      end
    end
  end
end