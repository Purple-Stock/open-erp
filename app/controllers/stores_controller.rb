class StoresController < ApplicationController
  before_action :set_store, only: %i[show edit update destroy]

  def index
    @search = Store.reverse_chronologically.ransack(params[:q])

    respond_to do |format|
      format.any(:html, :json) { @stores = set_page_and_extract_portion_from @search.result }
      format.csv { render csv: @search.result }
    end
  end

  def show
    fresh_when etag: @store
  end

  def new
    @store = Store.new
  end

  def edit; end

  def create
    @store = Store.new(store_params)
    @store.save!

    respond_to do |format|
      format.html { redirect_to @store, notice: 'Store was successfully created.' }
      format.json { render :show, status: :created }
    end
  end

  def update
    @store.update!(store_params)
    respond_to do |format|
      format.html { redirect_to @store, notice: 'Store was successfully updated.' }
      format.json { render :show }
    end
  end

  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_store
    @store = Store.find(params[:id])
  end

  def store_params
    params['product']['account_id'] = current_tenant.id
    params.require(:store).permit(:name, :address, :phone, :email, :account_id)
  end
end
