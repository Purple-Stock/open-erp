# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ForgeryProtection
  include SetPlatform
  before_action :authenticate_user!
  set_current_tenant_through_filter
  before_action :set_current_account
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout :layout_by_resource

  def set_current_account
    return if current_user.blank?

    current_account = current_user.account
    ActsAsTenant.current_tenant = current_account
  end

  protected

  def configure_permitted_parameters
    added_attrs = %i[company_name first_name cpf_cnpj phone last_name email password password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end 

  private

  def layout_by_resource
    if devise_controller?
      'auth'
    else
      'application'
    end
  end  

end
