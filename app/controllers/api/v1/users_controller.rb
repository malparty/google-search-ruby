# frozen_string_literal: true

module API
  module V1
    class UsersController < ApplicationController
      skip_before_action :doorkeeper_authorize!, only: :create

      before_action :ensure_valid_client, only: :create

      def create
        user = User.new(create_params.except(:client_id, :client_secret))

        if user.save
          render json: UserTokenSerializer.new(user, { params: { client_id: @client_app.id } }),
                 status: :created
        else
          render json: ActiveModel::ErrorsSerializer.new(user.errors)
        end
      end

      private

      def create_params
        params.permit(:email, :password, :last_name, :first_name, :client_id, :client_secret)
      end

      def ensure_valid_client
        @client_app = Doorkeeper::Application.by_uid_and_secret(create_params[:client_id],
                                                                create_params[:client_secret])

        render_error 'Invalid client credentials', status: :forbidden, source: :client_id if @client_app.blank?
      end
    end
  end
end
