# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Localization
  include DeviseParameter

  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :update_allowed_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_not_found
    render 'shared/404', status: :not_found
  end
end
