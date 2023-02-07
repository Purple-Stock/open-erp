class LocalesController < ApplicationController
  
  before_action :set_locale

  def default_locale_option
    cookies.delete(:locale)   
    cookies.permanent[:locale] = I18n.default_locale # save cookies with default language 
  end

  def set_locale
    if params[:locale].present?
      if params[:locale] == 'default'
        default_locale_option
      else
        cookies.permanent[:locale] = params[:locale] # save cookies    
      end
    end

    locale = cookies[:locale]&.to_sym # this reads cookies
  
    if I18n.available_locales.include?(locale)
      I18n.locale = locale # use cookies locale
      redirect_to request.referrer # to the same page
    end    
  end

end



