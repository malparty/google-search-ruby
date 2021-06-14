# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::ApplicationController
      skip_before_action :doorkeeper_authorize!, only: :create

      def create
        user = User.new(user_params)
        client_app = Doorkeeper::Application.find_by(uid: params[:client_id])
        return render(json: { error: 'Invalid client ID' }, status: :forbidden) unless client_app

        if user.save
          # create access token for the user, so the user won't need to login again after registration
          access_token = user.get_access_token client_app.id
          # return json containing access token and refresh token
          # so that user won't need to call login API right after registration
          render json: create_success_result(user, access_token)
        else
          render(json: { error: user.errors.full_messages }, status: :unprocessable_entity)
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

      def user_params
        params.permit(:email, :password, :lastname, :firstname)
      end
    end
  end
end
