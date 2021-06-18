# frozen_string_literal: true

module API
  module V1
    class TokensController < Doorkeeper::TokensController
      include ErrorHandlerConcern

      private

      # Overwrite this method as it bypass the custom_error_response provided by Doorkeeper
      def revocation_error_response
        error_description = I18n.t(:unauthorized, scope: %i[doorkeeper errors messages revoke])
        {
          errors: build_error(detail: error_description, code: :invalid_client)
        }
      end
    end
  end
end
