# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer

  attributes :email, :last_name, :first_name
end
