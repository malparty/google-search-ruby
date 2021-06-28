# frozen_string_literal: true

module API
  module V1
    class TokensController < Doorkeeper::TokensController
      include ErrorHandlerConcern

      # Overridden from doorkeeper as the doorkeeper revoke action does not return response according to json-api spec
      def revoke
        # The authorization server responds with HTTP status code 200 if the client
        # submitted an invalid token or the token has been revoked successfully.
        if token.blank?
          render json: token_revoke_response, status: :ok
          # The authorization server validates [...] and whether the token
          # was issued to the client making the revocation request. If this
          # validation fails, the request is refused and the client is informed
          # of the error by the authorization server as described below.
        elsif authorized?
          revoke_token
          render json: token_revoke_response, status: :ok
        else
          render json: revocation_error_response, status: :forbidden
        end
      end

      private

      # Overridden from doorkeeper as it does not return response according to json-api spec
      def revocation_error_response
        error_description = I18n.t(:unauthorized, scope: %i[doorkeeper errors messages revoke])
        {
          errors: build_error(detail: error_description, code: :invalid_client)
        }
      end

      def token_revoke_response
        { meta: I18n.t('doorkeeper.token_revoked') }
      end
    end
  end
end
