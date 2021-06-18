# frozen_string_literal: true

module ActiveModel
  class ErrorsSerializer
    def initialize(errors)
      @errors = errors
    end

    def serializable_hash
      { errors: @errors.errors.map { |e| { detail: e.full_message, source: e.attribute } } }
    end
  end
end
