# frozen_string_literal: true

module API
  module V1
    module ErrorHandlerConcern
      extend ActiveSupport::Concern

      private

      # Render Error Message in json_api format
      def render_error(detail:, source: nil, status: :unprocessable_entity)
        error = build_error(detail: detail, source: source)
        render_errors [error], status
      end

      def render_errors(jsonapi_errors, status = :unprocessable_entity)
        render json: { errors: jsonapi_errors }, status: status
      end

      def build_error(detail:, source: nil)
        {
          source: source,
          detail: detail
        }.compact
      end
    end
  end
end
