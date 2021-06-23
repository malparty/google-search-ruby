# frozen_string_literal: true

class UserTokenSerializer < UserSerializer
  set_type :user

  attribute :access_token do |user, params|
    Doorkeeper::TokenSerializer.new(user.create_access_token(params[:client_id])).serializable_hash[:data]
  end
end
