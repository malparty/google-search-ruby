# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Localization
  include DeviseParameter

  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :update_allowed_parameters, if: :devise_controller?
  end
end
