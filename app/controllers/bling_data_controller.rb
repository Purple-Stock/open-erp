class BlingDataController < ApplicationController
  before_action :set_bling_datum, only: [:show, :edit, :update, :destroy]

  # GET /bling_data
  def index
    @bling_data = BlingDatum.all
  end

  # GET /bling_data/1
  def show
  end

  # GET /bling_data/new
  def new
    @bling_datum = BlingDatum.new
  end

  # GET /bling_data/1/edit
  def edit
  end

  # POST /bling_data
  def create
    @bling_datum = BlingDatum.new(bling_datum_params)

    if @bling_datum.save
      redirect_to @bling_datum, notice: 'Bling datum was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /bling_data/1
  def update
    if @bling_datum.update(bling_datum_params)
      redirect_to @bling_datum, notice: 'Bling datum was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /bling_data/1
  def destroy
    @bling_datum.destroy
    redirect_to bling_data_url, notice: 'Bling datum was successfully destroyed.'
  end

  private

  def set_bling_datum
    @bling_datum = BlingDatum.find(params[:id])
  end

  def bling_datum_params
    params.require(:bling_datum).permit(:access_token, :expires_at, :expires_in, :refresh_token, :scope, :token_type, :account_id)
  end
end
