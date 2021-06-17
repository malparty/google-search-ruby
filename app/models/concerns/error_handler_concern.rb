# frozen_string_literal: true

module ErrorHandlerConcern
  extend ActiveSupport::Concern

  # Enhance errors to JSON::API standards
  def jsonapi_errors
    errors.errors.map { |e| { detail: e.full_message, source: e.attribute } }
  end
end
