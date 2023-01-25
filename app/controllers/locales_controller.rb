class LocalesController < ApplicationController
  
  before_action :set_locale

  def set_locale
    session[:locale] = params[:locale] if params[:locale].present?
    I18n.locale = session[:locale] || I18n.default_locale

    redirect_to request.referrer
  end 

end



