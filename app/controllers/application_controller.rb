# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Localization

  protect_from_forgery with: :exception

  before_action :update_allowed_parameters, if: :devise_controller?

  protected

  def update_allowed_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:firstname, :lastname, :email, :password) }
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:firstname, :lastname, :email, :password, :current_password)
    end
  end
end
