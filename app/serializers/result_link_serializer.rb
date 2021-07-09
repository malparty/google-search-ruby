# frozen_string_literal: true

class ResultLinkSerializer
  include JSONAPI::Serializer

  attributes :link_type, :url, :created_at

  belongs_to :keyword
end
