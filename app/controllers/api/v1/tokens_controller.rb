# frozen_string_literal: true

module API
  module V1
    class TokensController < Doorkeeper::TokensController
      include ErrorHandlerConcern

      after_action :handle_jsonapi_success

      private

      # Overwrite this method as it bypass the custom_error_response provided by Doorkeeper
      def revocation_error_response
        error_description = I18n.t(:unauthorized, scope: %i[doorkeeper errors messages revoke])
        {
          errors: build_error(detail: error_description, code: :invalid_client)
        }
      end

      def handle_jsonapi_success
        set_revoke_response if (200..299).cover?(response.status) && action_name == 'revoke'
      end

      def set_revoke_response
        response.body = { meta: I18n.t('doorkeeper.token_revoked') }.to_json
      end
    end
  end
end
