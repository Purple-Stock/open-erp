class TailorsController < ApplicationController
  before_action :set_tailor, only: [:show, :edit, :update, :destroy]

  def index
    @tailors = Tailor.all
  end

  def show
  end

  def new
    @tailor = Tailor.new
  end

  def edit
  end

  def create
    @tailor = Tailor.new(tailor_params)
    if @tailor.save
      redirect_to @tailor, notice: 'Costureiro Criado com sucesso.'
    else
      render :new
    end
  end

  def update
    if @tailor.update(tailor_params)
      redirect_to @tailor, notice: 'Costureiro Atualizado com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @tailor.destroy
    redirect_to tailors_url, notice: 'Costureiro Removido com sucesso.'
  end

  private

    def set_tailor
      @tailor = Tailor.find(params[:id])
    end

    def tailor_params
      params['tailor']['account_id'] = current_tenant.id
      params.require(:tailor).permit(:name, :production_id, :account_id)
    end
end
