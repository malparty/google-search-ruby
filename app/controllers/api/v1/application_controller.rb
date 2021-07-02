# frozen_string_literal: true

module API
  module V1
    class ApplicationController < ActionController::API
      include ErrorHandlerConcern

      # equivalent of authenticate_user! on devise, but this one will check the oauth token
      before_action :doorkeeper_authorize!

      rescue_from ::Pagy::VariableError do |e|
        render_error(details: I18n.t('pagy.errors.variable'), source: e.variable, status: :unprocessable_entity)
      end

      rescue_from ::Pagy::OverflowError do |e|
        render_error(
          details: "#{I18n.t('pagy.errors.overflow')} #{e.pagy.last}",
          source: e.variable,
          status: :unprocessable_entity
        )
      end

      private

      # helper method to access the current user from the token
      def current_user
        @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id])
      end
    end
  end
end
