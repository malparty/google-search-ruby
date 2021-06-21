# frozen_string_literal: true

module Doorkeeper
  class TokenSerializer
    include JSONAPI::Serializer

    attributes :token, :token_type, :expires_in, :refresh_token

    attribute :created_at do |token|
      token.created_at.to_time.to_i
    end
  end
end
