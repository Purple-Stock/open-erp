class LocalesController < ApplicationController
  
  before_action :set_locale

  def default_url_option
    cookie.delete(:locale)
    locale =  I18n.locale
    redirect_to request.referrer    
  end

  def set_locale
    if params[:locale].present?
      locale = params[:locale] 
      cookies.permanent[:locale] = params[:locale] # save cookies
    end

    locale = cookies[:locale]&.to_sym # this read cookies
  
    if I18n.available_locales.include?(locale)
      I18n.locale = locale # use cookies locale
      redirect_to request.referrer # to the same page
    end    
  end

end



