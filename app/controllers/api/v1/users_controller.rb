# frozen_string_literal: true

module API
  module V1
    class UsersController < API::V1::ApplicationController
      include API::V1::ErrorHandlerConcern

      skip_before_action :doorkeeper_authorize!, only: :create

      def create
        user = User.new(create_params.except(:client_id))
        client_app = Doorkeeper::Application.find_by(uid: create_params[:client_id])

        unless client_app
          render_error detail: 'Invalid client ID', status: :forbidden, source: :client_id
          return
        end

        if user.save
          # create access token for the user, so the user won't need to login again after registration
          access_token = user.get_access_token client_app.id
          # return json containing access token and refresh token
          # so that user won't need to call login API right after registration
          render json: create_success_result(user, access_token), status: :created

        else
          render_errors user.jsonapi_errors
        end
      end

      private

      def create_success_result(user, access_token)
        user_json = UserSerializer.new(user).serializable_hash
        token_json = Doorkeeper::TokenSerializer.new(access_token).serializable_hash
        { data: [
          user_json[:data],
          token_json[:data]
        ] }
      end

      def create_params
        params.permit(:email, :password, :last_name, :first_name, :client_id)
      end
    end
  end
end
