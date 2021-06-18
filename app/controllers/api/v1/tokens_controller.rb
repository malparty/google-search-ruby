# frozen_string_literal: true

module API
  module V1
    class TokensController < Doorkeeper::TokensController
      include ErrorHandlerConcern
      include JsonAPIHandlerConcern

      private

      def revocation_error_response
        error_description = I18n.t(:unauthorized, scope: %i[doorkeeper errors messages revoke])
        {
          errors: build_error(detail: error_description, code: :unauthorized_client)
        }
      end
    end
  end
end
