# frozen_string_literal: true

class ResultLinkSerializer
  include JSONAPI::Serializer

  attributes :url, :link_type, :created_at
end
