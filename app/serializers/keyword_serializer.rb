# frozen_string_literal: true

class KeywordSerializer
  include JSONAPI::Serializer

  attributes :name, :created_at
end
