class LocalesController < ApplicationController
  
  before_action :set_locale

  def default_url_options
    { locale: I18n.locale }
  end

  def set_locale
    if params[:locale].present?
      locale = params[:locale] 
      cookies.permanent[:locale] = params[:locale] # save cookies
    end

    #if params[:locale].present?
      #locale = params[:locale] || I18n.default_locale
      #cookies.permanent[:locale] = params[:locale] # save cookies
    #end    
   
    locale = cookies[:locale]&.to_sym # this read cookies
  
    if I18n.available_locales.include?(locale)
      I18n.locale = locale # use cookies locale
      redirect_to request.referrer # to the same page
    else
      I18n.default_locale
      redirect_to request.referrer
    end
  end

end



