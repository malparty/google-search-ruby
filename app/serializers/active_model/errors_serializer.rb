# frozen_string_literal: true

module ActiveModel
  class ErrorsSerializer
    def initialize(errors)
      @errors = errors
    end

    def as_json(_options = nil)
      { errors: @errors.errors.map { |e| { detail: e.full_message, source: e.attribute } } }
    end
  end
end
