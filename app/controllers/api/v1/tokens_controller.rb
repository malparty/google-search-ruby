# frozen_string_literal: true

module API
  module V1
    class TokensController < Doorkeeper::TokensController
      include ErrorHandlerConcern

      after_action :handle_jsonapi_errors, only: %i[revoke create]
      after_action :handle_jsonapi_revoke, only: :revoke
      after_action :handle_jsonapi_create, only: :create

      private

      def revocation_error_response
        error_description = I18n.t(:unauthorized, scope: %i[doorkeeper errors messages revoke])
        {
          errors: build_error(detail: error_description, code: :unauthorized_client)
        }
      end

      def handle_jsonapi_revoke
        response.body = { meta: I18n.t('doorkeeper.token_revoked') }.to_json if response.status == 200
      end

      def handle_jsonapi_create
        return unless response.status == 200

        response.body = { data: { id: 1, type: :token, attributes: JSON.parse(response.body) } }.to_json
        response.status = 201
      end

      def handle_jsonapi_errors
        return if (200..299).cover? response.status

        resp = JSON.parse(response.body)
        Rails.logger.debug resp
        result = { errors: [build_error(detail: resp['error_description'], code: resp['error'])] }

        response.body = result.to_json
      end
    end
  end
end
