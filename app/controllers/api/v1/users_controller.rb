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
          render_error 'Invalid client ID', status: :forbidden, source: :client_id
          return
        end

        render_errors ActiveModel::ErrorsSerializer.new(user.errors).serializable_hash and return unless user.save

        render json: UserTokenSerializer.new(user, { params: { client_id: client_app.id } }).serializable_hash,
               status: :created
      end

      private

      def create_params
        params.permit(:email, :password, :last_name, :first_name, :client_id)
      end
    end
  end
end
