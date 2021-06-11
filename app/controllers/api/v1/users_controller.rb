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
          access_token = get_access_token user.id, client_app.id
          # return json containing access token and refresh token
          # so that user won't need to call login API right after registration
          render json: create_success_result(user, access_token)
        else
          render(json: { error: user.errors.full_messages }, status: :unprocessable_entity)
        end
      end

      private

      def get_access_token(user_id, client_app_id)
        Doorkeeper::AccessToken.create(
          resource_owner_id: user_id,
          application_id: client_app_id,
          refresh_token: generate_refresh_token,
          expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
          scopes: ''
        )
      end

      def create_success_result(user, access_token)
        { user: {
          id: user.id,
          email: user.email,
          access_token: access_token.token,
          token_type: 'bearer',
          expires_in: access_token.expires_in,
          refresh_token: access_token.refresh_token,
          created_at: access_token.created_at.to_time.to_i
        } }
      end

      def user_params
        params.permit(:email, :password, :lastname, :firstname)
      end

      def generate_refresh_token
        loop do
          # generate a random token string and return it,
          # unless there is already another token with the same string
          token = SecureRandom.hex(32)
          break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
        end
      end
    end
  end
end
