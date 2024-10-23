class BlingModuleSituationsController < ApplicationController
  before_action :set_bling_module_situation, only: [:show, :edit, :update, :destroy]

  def index
    @bling_module_situations = BlingModuleSituation.all.order(:module_id, :situation_id)
  end

  def show
  end

  def new
    @bling_module_situation = BlingModuleSituation.new
  end

  def create
    @bling_module_situation = BlingModuleSituation.new(bling_module_situation_params)
    if @bling_module_situation.save
      redirect_to @bling_module_situation, notice: t('bling_module_situations.create_success')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @bling_module_situation.update(bling_module_situation_params)
      redirect_to @bling_module_situation, notice: t('bling_module_situations.update_success')
    else
      render :edit
    end
  end

  def destroy
    @bling_module_situation.destroy
    redirect_to bling_module_situations_url, notice: t('bling_module_situations.destroy_success')
  end

  private

  def set_bling_module_situation
    @bling_module_situation = BlingModuleSituation.find(params[:id])
  end

  def bling_module_situation_params
    params.require(:bling_module_situation).permit(:situation_id, :name, :module_id, :inherited_id, :color)
  end
end
