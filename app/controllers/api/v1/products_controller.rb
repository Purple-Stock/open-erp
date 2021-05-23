class Api::V1::ProductsController < ActionController::Base
  def show
    @product = Product.find_by(custom_id: params[:custom_id])
  end

  def show_product
    @product = Product.find(params[:id])
  end

  def index
    @products = Product.where(active: true)
  end
end
