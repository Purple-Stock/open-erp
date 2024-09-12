# app/controllers/productions_controller.rb

class ProductionsController < ApplicationController
  before_action :set_production, only: [:show, :edit, :update, :destroy, :verify]
  before_action :set_tailors, only: [:new, :edit, :create, :update]

  def index
    @productions = Production.includes(:tailor, production_products: :product).all
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
                                                                             .where('quantity > COALESCE(pieces_delivered, 0) + COALESCE(dirty, 0) + COALESCE(error, 0) + COALESCE(discard, 0)'))
                                                 .distinct

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
      :cut_date, :tailor_id, :service_order_number, :expected_delivery_date,
      :confirmed, :paid, :consider, :observation,
      production_products_attributes: [:id, :product_id, :quantity, :pieces_delivered, :delivery_date,
                                     :dirty, :error, :discard, :_destroy]
    )
  end

  def calculate_tailors_summary(productions)
    productions.each_with_object({}) do |production, summary|
      tailor_id = production.tailor_id
      summary[tailor_id] ||= { productions_count: 0, total_missing_pieces: 0, products: {} }
      summary[tailor_id][:productions_count] += 1

      production.production_products.each do |pp|
        missing_pieces = pp.quantity - ((pp.pieces_delivered || 0) + (pp.dirty || 0) + (pp.error || 0) + (pp.discard || 0))
        if missing_pieces > 0
          summary[tailor_id][:total_missing_pieces] += missing_pieces
          summary[tailor_id][:products][pp.product_id] ||= 0
          summary[tailor_id][:products][pp.product_id] += missing_pieces
        end
      end
    end
  end
end