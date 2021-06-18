# frozen_string_literal: true

module API
  module V1
    module JsonAPIHandlerConcern
      extend ActiveSupport::Concern

      included do
        after_action :handle_jsonapi_errors
        after_action :handle_jsonapi_success
      end

      private

      def handle_jsonapi_success
        return unless (200..299).cover? response.status

        if action_name == 'revoke'
          set_revoke_response
          return
        end

        return unless action_name == 'create'

        set_create_response
      end

      def set_revoke_response
        response.body = { meta: I18n.t('doorkeeper.token_revoked') }.to_json
      end

      def set_create_response
        response.body = { data: { id: 1, type: :token, attributes: JSON.parse(response.body) } }.to_json
        response.status = 201
      end

      def handle_jsonapi_errors
        return if (200..299).cover? response.status

        resp = JSON.parse(response.body)
        result = { errors: [build_error(detail: resp['error_description'], code: resp['error'])] }

        response.body = result.to_json
      end
    end
  end
end
